$: << File.expand_path('..' ) unless ENV["sniper_in_rake"]
require 'sandbox'
require 'microtests/testutil'

require 'app/auction-message-translator'
require 'app/auction-sniper'

class AuctionSniperTests < Test::Unit::TestCase
  include AuctionMessageTranslator::PriceSource

  def setup
    @auction = flexmock('auction')
    @sniper_listener = flexmock("sniper listener")
    @sniper = AuctionSniper.new(@auction, @sniper_listener, "some item id")
  end

  should "report that sniper lost when the auction closes immediately" do 
    during {
      @sniper.auction_closed
    }.behold! {
      @sniper_listener.should_receive(:sniper_lost).at_least.once
    }
  end

  should "report that sniper lost when the auction closes while someone else has high bid" do
    @auction.should_ignore_missing
    during {
      @sniper.current_price(123, 45, FROM_OTHER_BIDDER)
      @sniper.auction_closed
    }.behold! {
      @sniper_listener.should_receive(:sniper_bidding).
                       which_means("someone else is in the lead")
      @sniper_listener.should_receive(:sniper_lost).at_least.once.
                       when("someone else is in the lead")
    }
  end
  
  should "bid higher (and so report) when a new price arrives" do 
    price = 1001
    increment = 25
    bid = price+increment
    during {
      @sniper.current_price(price, increment, "ignored source")
    }.behold! {
      @auction.should_receive(:bid).once.with(bid)
      @sniper_listener.should_receive(:sniper_bidding).at_least.once.
                       with(SniperState.new(:item_id => @sniper.item_id,
                                            :last_price => price,
                                            :last_bid => bid))
    }
  end

  should "report that the sniper is winning when the current price came from it" do
    during {
      @sniper.current_price(123, 45, FROM_SNIPER)
    }.behold! {
      @sniper_listener.should_receive(:sniper_winning).at_least.once
    }
  end

  should "report that sniper lost when the auction closes while the sniper is winning" do
    @auction.should_ignore_missing
    during {
      @sniper.current_price(123, 45, FROM_SNIPER)
      @sniper.auction_closed
    }.behold! {
      @sniper_listener.should_receive(:sniper_winning).
                       which_means("the sniper is winning")
      @sniper_listener.should_receive(:sniper_won).at_least.once.
                       when("the sniper is winning")
    }
  end
  
end
