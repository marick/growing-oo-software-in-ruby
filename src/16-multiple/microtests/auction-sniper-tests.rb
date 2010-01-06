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
      @sniper_listener.should_receive(:sniper_state_changed).at_least.once.
                       with(a_sniper_that_is(SniperState::LOST))
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
      @sniper_listener.should_receive(:sniper_state_changed).at_least.once.
                       with(SniperSnapshot.new(:item_id => @sniper.item_id,
                                               :last_price => price,
                                               :last_bid => bid,
                                               :state => SniperState::BIDDING))
    }
  end

  # Note: it's unclear to me if "last bid" means "last thing I bid,
  # whether accepted or not" or "last bid that's been accepted". Given
  # the structure of the app, I think it has to be the former, in
  # which case the last bid can be higher than the last price, as
  # shown below.
  should "report that sniper lost when the auction closes while someone else has high bid" do
    @auction.should_ignore_missing
    during {
      @sniper.current_price(123, 45, FROM_OTHER_BIDDER)
      @sniper.auction_closed
    }.behold! {
      @sniper_listener.should_receive(:sniper_state_changed).
                       with(a_sniper_that_is(SniperState::BIDDING)).
                       which_means("someone else is in the lead")
      @sniper_listener.should_receive(:sniper_state_changed).at_least.once.
                       with(SniperSnapshot.new(:item_id => @sniper.item_id,
                                               :last_price => 123,
                                               :last_bid => 168,
                                               :state => SniperState::LOST)).
                       when("someone else is in the lead")
    }
  end
  

  should "report that the sniper is winning when the current price came from it" do
    @auction.should_ignore_missing
    during {
      @sniper.current_price(123, 12, FROM_OTHER_BIDDER)
      @sniper.current_price(135, 45, FROM_SNIPER)
    }.behold! {
      @sniper_listener.should_receive(:sniper_state_changed).
                       with(a_sniper_that_is(SniperState::BIDDING)).
                       which_means("the sniper is bidding")
      @sniper_listener.should_receive(:sniper_state_changed).at_least.once.
                       with(SniperSnapshot.new(:item_id => @sniper.item_id,
                                               :last_price => 135,
                                               :last_bid => 135, 
                                               :state => SniperState::WINNING)).
                       when("the sniper is bidding")
    }
  end

  # I've changed this from #goos to emphasize that bidding happens before 
  # learning you've won. (Without this, the test would show the winning 
  # bid as 0 - since one never went out.)

  should "report that sniper won when the auction closes while the sniper is winning" do
    @auction.should_ignore_missing
    during {
      @sniper.current_price(123, 12, FROM_OTHER_BIDDER)
      @sniper.current_price(135, 45, FROM_SNIPER)
      @sniper.auction_closed
    }.behold! {
      @sniper_listener.should_receive(:sniper_state_changed).
                       with(a_sniper_that_is(SniperState::BIDDING))
      @sniper_listener.should_receive(:sniper_state_changed).
                       with(a_sniper_that_is(SniperState::WINNING)).
                       which_means("the sniper is winning")
      @sniper_listener.should_receive(:sniper_state_changed).at_least.once.
                       with(SniperSnapshot.new(:item_id => @sniper.item_id,
                                               :last_price => 135,
                                               :last_bid => 135, 
                                               :state => SniperState::WON)).
                       when("the sniper is winning")
    }
  end


  def a_sniper_that_is(state)
    on { | snapshot | 
      snapshot.state == state
    }
  end


  
end
