require 'external/util'
require 'logger'

module XMPP
  Log = Logger.new($stdout)
  Log.level = Logger::WARN
  
  class Chat
    attr_reader :name
    
    def initialize(name)
      @name = name
      @message_listeners = {}
    end

    def participant
      @last_sender
    end

    def add_message_listener(user, listener)
      @message_listeners[user] = listener
    end

    def send_message(sending_user, text)
      @last_sender = sending_user
      @message_listeners.each do | user, listener |
        next if user == sending_user
        Log.debug(me("forwarding #{text} to listeners #{listener.class}@#{listener.object_id}."))
        message = Message.new
        message.body = text
        listener.process_message(self, message)
      end
    end
  end

  class Endpoint
    attr_reader :user

    def initialize(user, extras = {})
      @user = user
      @on_chat_creation = extras[:on_chat_creation]
      @chat = extras[:chat]
    end

    def self.passive(user, block)
      new(user, :on_chat_creation => block)
    end

    def self.active(user, chat)
      new(user, :chat => chat)
    end

    def other_end_arrives(chat)
      Log.debug(me("forwarding new chat listeners #{@on_chat_creation.inspect}."))
      @chat = chat
      @on_chat_creation.call(self, false)
    end

    def send_message(text)
      @chat.send_message(@user, text)
    end

    def add_message_listener(listener)
      @chat.add_message_listener(@user, listener)
    end

    def participant; @chat.participant; end
  end


  HALF_OPENS = []

  def self.reinitialize
    HALF_OPENS.slice!(0,0)
  end

  class Connection 
    attr_reader :service_name
    attr_reader :user

    def initialize(host)
      Log.info("Set service name to #{host}")
      @service_name = host
    end

    def login(name, password, resource)
      @user = name
      @id = "#{name}@#{service_name}/#{resource}"
    end

    def connect
      # do nothing
    end

    def disconnect
      # do nothing
    end

    def chat_manager; self; end

    def add_chat_listener(&block)
      endpoint = Endpoint.passive(user, block)
      HALF_OPENS << endpoint
    end

    def create_chat(chat_name, message_listener)
      chat = Chat.new(chat_name)
      chat.add_message_listener(user, message_listener) if message_listener

      HALF_OPENS.find_all { | ho | 
        chat_name =~ /#{ho.user}@/
      }.each { | ho |
        ho.other_end_arrives(chat)
      }

      Endpoint.active(user, chat)
    end
  end

  class Message
    attr_accessor :body
  end

end
