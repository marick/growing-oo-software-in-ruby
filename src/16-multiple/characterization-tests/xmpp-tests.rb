# Fake XMPP has gotten complicated enough that I have to TDD next changes.

$: << File.expand_path('..' ) unless ENV["sniper_in_rake"]
require 'sandbox'
require 'characterization-tests/testutil'

TestLogger.level = Logger::WARN

class MessageListener

  attr_reader :name

  def initialize(name)
    @name = name
    @messages = []
  end

  def process_message(chat, message)
    TestLogger.debug "#{name} got #{message.inspect}"
    @messages << message
  end

  def pop; @messages.shift; end
  def empty?; @messages.empty?; end
end

require 'external/xmpp'

class XMPPTests < Test::Unit::TestCase

  def setup
    XMPP.reinitialize
  end

  should "handle one connection at once" do 
    server_connection = common_connection_and_login("auction-1")
    prepare_for_chat(server_connection)

    client_connection = common_connection_and_login("sniper")
    client_chat, client_message_listener = create_chat(client_connection, 'auction-1')

    server_chat, server_message_listener = accept_chat
    
    send_message(client_chat, "client says hi")
    assert { client_message_listener.empty? } 
    assert { server_message_listener.pop.body == "client says hi" } 
    send_message(server_chat, "server says hi")
    assert { server_message_listener.empty? } 
    assert { client_message_listener.pop.body == "server says hi" } 
  end

  should "chats do not intermingle their messages" do 
    server_connection = common_connection_and_login("auction-1")
    prepare_for_chat(server_connection)

    server_2_connection = common_connection_and_login("auction-2")
    prepare_for_chat(server_2_connection)

    # Note: only one client connection
    client_connection = common_connection_and_login("sniper")
    client_chat, client_message_listener = create_chat(client_connection, 'auction-1')
    server_chat, server_message_listener = accept_chat

    client_2_chat, client_2_message_listener = create_chat(client_connection, 'auction-1')
    server_2_chat, server_2_message_listener = accept_chat

    # 
    send_message(client_chat, "client says hi")
    assert { client_message_listener.empty? } 
    assert { client_2_message_listener.empty? } 
    assert { server_message_listener.pop.body == "client says hi" } 
    assert { server_2_message_listener.empty? } 


    send_message(server_2_chat, "server says hi")
    assert { client_message_listener.empty? } 
    assert { client_2_message_listener.pop.body == "server says hi" } 
    assert { server_message_listener.empty? } 
    assert { server_2_message_listener.empty? } 
  end

  def common_connection_and_login(login)
    connection = XMPP::Connection.new('localhost')
    connection.connect
    connection.login(login, "ignored password", "resource")
    connection
  end

  def prepare_for_chat(connection)
    connection.chat_manager.add_chat_listener do | chat, ignored | 
      @returned_chat = chat
    end
  end

  def accept_chat
    message_listener = MessageListener.new("passive listener")
    @returned_chat.add_message_listener(message_listener)
    return @returned_chat, message_listener
  end

  def create_chat(connection, chat_name)
    chat = connection.chat_manager.create_chat("#{chat_name}@localhost/resource",
                                               nil)
    message_listener = MessageListener.new("active listener")
    chat.add_message_listener(message_listener)
    return chat, message_listener
  end

  def send_message(chat, body)
    chat.send_message(body)
  rescue Exception => ex
    puts "========= #{ex.message}" 
    puts ex.backtrace
    flunk
  end
end
