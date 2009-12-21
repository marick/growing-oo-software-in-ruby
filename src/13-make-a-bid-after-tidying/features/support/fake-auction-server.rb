require 'external/xmpp'
require 'external/util'
require 'app/sol-text'
require 'thread'
require 'timeout'
require 'assert2'

class FakeAuctionServer
  include Test::Unit::Assertions
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

  def has_received_join_request_from?(sniper_id)
    @message_listener.with_next_message do | message | 
      assert { message.body == SOLText.join } 
      assert { sniper_id == @current_chat.participant }
    end
  end

  def report_price(price, increment, bidder)
    @current_chat.send_message(SOLText.price(price, increment, bidder))
  end

  def has_received_bid?(bid, sniper_id)
    @message_listener.with_next_message do | message |
      assert { message.body == SOLText.bid(bid) }
      assert { sniper_id == @current_chat.participant }
    end
  end

  def announce_closed
    @current_chat.send_message(SOLText.close)
  end

  def stop
    @connection.disconnect
  end
end


class SingleMessageListener
  def initialize
    @messages = BlockingQueue.new
  end

  def process_message(chat, message)  # called from XMPP server
    TestLogger.debug(me("stashing away #{message}."))
    @messages.enqueue(message)
  end

  def with_next_message  
    yield @messages.dequeue
  end
end
