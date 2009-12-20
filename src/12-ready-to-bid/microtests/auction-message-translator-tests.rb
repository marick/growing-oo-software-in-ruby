$: << File.expand_path('..' ) unless ENV["sniper_in_rake"]
require 'sandbox'
require 'microtests/testutil'

require 'app/auction-message'
require 'app/auction-message-translator'
require 'external/xmpp'

class AuctionMessageTranslatorTests < Test::Unit::TestCase
  def setup
    @listener = flexmock("listener")
    @translator = AuctionMessageTranslator.new(@listener)
  end

  should "notify that the auction is closed when the 'Close' message is received" do 
    message = XMPP::Message.new
    message.body = AuctionMessage.close_message
    during {
      @translator.process_message('unused chat argument', message)
    }.behold! {
      @listener.should_receive(:auction_closed).once
    }
  end

  should "notify of bid details when the current price message is received" do
    message = XMPP::Message.new
    message.body = AuctionMessage.price_message(192, 7, "someone else")
    during {
      @translator.process_message('unused chat argument', message)
    }.behold! {
      @listener.should_receive(:current_price).once.
                with(192, 7)
    }
  end
end
