$: << File.expand_path('..' ) unless ENV["sniper_in_rake"]
require 'sandbox'
require 'microtests/testutil'

require 'app/auction-message'
require 'app/auction-message-translator'

class AuctionMessageTranslatorTests < Test::Unit::TestCase
  def setup
    @listener = flexmock("listener")
    @translator = AuctionMessageTranslator.new(@listener)
  end

  should "notify that the auction is closed when the 'Close' message is received" do 
    during {
      @translator.process_message('unused chat argument', AuctionMessage.close_message)
    }.behold! {
      @listener.should_receive(:auction_closed).once
    }
  end
end
