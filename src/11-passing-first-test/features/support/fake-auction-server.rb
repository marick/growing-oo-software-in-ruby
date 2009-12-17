require 'external/xmpp'
require 'external/util'
require 'thread'
require 'timeout'

class FakeAuctionServer
  ITEM_ID_AS_LOGIN = "auction-%s"
  AUCTION_RESOURCE = "Auction"
  AUCTION_PASSWORD = "auction"

  attr_reader :item_id

  def initialize(item_id)
    @item_id = item_id
    @connection = XMPP::Connection.new(XMPP_HOSTNAME)
  end

  def start_selling_item
    @connection.connect
    @connection.login(sprintf(ITEM_ID_AS_LOGIN, item_id),
                      AUCTION_PASSWORD, AUCTION_RESOURCE)
    TestLogger.info(me("connects to XMPP server."))
    # This is initialized before the block below because it's possible the test 
    # can run ahead and call has_received_join_request_from_sniper? before the block 
    # finishes. So we need there to be a @message_listener there for it to block on.
    @message_listener = SingleMessageListener.new
    @connection.chat_manager.add_chat_listener do | chat, created_locally |
      TestLogger.info(me("is notified of an auction participant."))
      @current_chat = chat
      @current_chat.add_message_listener(@message_listener)
    end
  end

  def has_received_join_request_from_sniper?
    @message_listener.received_a_message?
  end

  def announce_closed
    @current_chat.send_message(XMPP::Message.new)
  end

  def stop
    @connection.disconnect
  end
end


class SingleMessageListener
  def initialize
    @messages = BlockingQueue.new
  end

  def process_message(chat, message)
    TestLogger.debug(me("stashing away #{message}."))
    @messages << message
  end

  def received_a_message?
    TestLogger.debug(me("checking for message."))
    @messages.has_entry?
  end
end
