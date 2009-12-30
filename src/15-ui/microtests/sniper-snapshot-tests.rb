$: << File.expand_path('..' ) unless ENV["sniper_in_rake"]
require 'sandbox'
require 'microtests/testutil'

require 'app/sniper-snapshot'

class SniperSnapshotTests < Test::Unit::TestCase
  include SniperState

  def setup
    @bogus = SniperSnapshot.new(:item_id => "bogus item",
                                :last_price => "bogus price",
                                :last_bid => "bogus bid",
                                :state => "bogus state")
  end

  should "have a class method that allows joining" do 
    snapshot = SniperSnapshot.joining(:item_id => "auction-12")
    assert_equal(SniperSnapshot.new(:item_id => "auction-12", 
                                    :last_price => 0,
                                    :last_bid => 0,
                                    :state => JOINING),
                 snapshot)
  end

  should "have joining method that overwrites all values" do
    snapshot = @bogus.joining(:item_id => "auction-12")
    assert_equal(SniperSnapshot.new(:item_id => "auction-12", 
                                    :last_price => 0,
                                    :last_bid => 0,
                                    :state => JOINING),
                 snapshot)
  end


  should "have bidding method that changes price, bid, and state" do
    snapshot = @bogus.bidding(:last_price => 300, :last_bid => 999)
    assert_equal(SniperSnapshot.new(:item_id => "bogus item", 
                                    :last_price => 300,
                                    :last_bid => 999,
                                    :state => BIDDING),
                 snapshot)
  end

  should "have winning method that changes last price and state" do
    snapshot = @bogus.winning(:last_price => 333)
    assert_equal(SniperSnapshot.new(:item_id => "bogus item", 
                                    :last_price => 333,
                                    :last_bid => "bogus bid",
                                    :state => WINNING),
                 snapshot)
  end

  should "mark the auction won if winning when it closed" do
    snapshot = @bogus.winning(:last_price => 333).closed
    assert_equal(SniperSnapshot.new(:item_id => "bogus item", 
                                    :last_price => 333,
                                    :last_bid => "bogus bid",
                                    :state => WON),
                 snapshot)
  end

  should "mark the auction lost unless winning when it closed" do
    snapshot = @bogus.closed
    assert_equal(SniperSnapshot.new(:item_id => "bogus item", 
                                    :last_price => "bogus price",
                                    :last_bid => "bogus bid",
                                    :state => LOST),
                 snapshot)
  end

end


