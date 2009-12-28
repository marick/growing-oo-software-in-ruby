require 'app/auction-message-translator'
require 'app/sniper-state'
require 'app/sniper-snapshot'

class AuctionSniper
  include AuctionMessageTranslator::PriceSource

  attr_reader :item_id
  
  def initialize(auction, sniper_listener, item_id)
    @auction = auction
    @sniper_listener = sniper_listener
    @item_id = item_id
    @is_winning = false
  end

  def auction_closed
    if @is_winning
      @sniper_listener.sniper_won
    else
      @sniper_listener.sniper_lost
    end
  end

  def current_price(price, increment, source)
    @is_winning = (source == FROM_SNIPER)
    if @is_winning
      @sniper_listener.sniper_winning
    else
      bid = price + increment
      snapshot = SniperSnapshot.new(:item_id => item_id,
                                    :last_price => price,
                                    :last_bid => bid,
                                    :state => SniperState::BIDDING)
      App::Log.info("Sniper upping bid: #{snapshot.inspect}")
      @auction.bid(bid)
      @sniper_listener.sniper_bidding(snapshot)
    end
  end
end
