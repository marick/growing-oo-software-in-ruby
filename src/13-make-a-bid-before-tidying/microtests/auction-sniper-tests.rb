$: << File.expand_path('..' ) unless ENV["sniper_in_rake"]
require 'sandbox'
require 'microtests/testutil'

require 'app/auction-sniper'

class AuctionSniperTests < Test::Unit::TestCase
  def setup
    @auction = flexmock('auction')
    @sniper_listener = flexmock("sniper listener")
    @sniper = AuctionSniper.new(@auction, @sniper_listener)
  end

  should "report that sniper lost when the auction closes" do 
    during {
      @sniper.auction_closed
    }.behold! {
      @sniper_listener.should_receive(:sniper_lost).at_least.once
    }
  end

  should "bid higher (and so report) when a new price arrives" do 
    price = 1001
    increment = 25
    during {
      @sniper.current_price(price, increment)
    }.behold! {
      @auction.should_receive(:bid).once.with(price + increment)
      @sniper_listener.should_receive(:sniper_bidding).at_least.once
    }
  end

end
