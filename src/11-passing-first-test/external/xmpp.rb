require 'external/util'
require 'ostruct'

module XMPP

  class Rendezvous

    def initialize
      @chat_listeners = {}
      @message_listeners = {}
    end

    def self.instance
      return @default if @default
      @default = new
    end

    def add_chat_listener(connection, block)
      TestLogger.debug(me("connecting new chat listener #{block.inspect}"))
      @chat_listeners[connection] = block
    end

    def inform_chat_listeners(connection, local)
      TestLogger.info(me("forwarding new chat to listeners #{@chat_listeners}."))
      @chat_listeners.each do | creator_connection, listener | 
        next if connection == creator_connection
        listener.call(creator_connection, false)
      end
    end

    def add_message_listener(connection, listener)
      @message_listeners[connection] = listener
    end

    def broadcast(from_connection, message)
      TestLogger.info(me("forwarding message to listeners #{@message_listeners}."))
      @message_listeners.each do | connection, listener |
        next if connection == from_connection
        listener.process_message(from_connection, message)
      end
    end

    def disconnect(connection)
      @message_listeners.delete(connection)
      @chat_listeners.delete(connection)
    end
  end

  class Connection  # For now, glom together Connection, ChatManager, and Chat
    attr_reader :service_name

    def initialize(host)
      TestLogger.info("Set service name to #{host}")
      @service_name = host
      @rendezvous = Rendezvous.instance
    end

    def connect
      # do nothing
    end

    def disconnect
      @rendezvous.disconnect(self)
    end

    def login(name, password, resource)
    end

    def chat_manager; self; end

    def add_chat_listener(&block)
      @rendezvous.add_chat_listener(self, block)
    end

    def create_chat(chat_name, creator_message_listener)
      @rendezvous.inform_chat_listeners(self, false)
      @rendezvous.add_message_listener(self, creator_message_listener)
      self
    end
    
    def add_message_listener(listener)
      @rendezvous.add_message_listener(self, listener)
    end

    def send_message(message)
      @rendezvous.broadcast(self, message)
    end
  end

  class Message
  end

end
