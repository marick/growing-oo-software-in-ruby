require 'app/auction-message-translator'
require 'app/sniper-snapshot'

class AuctionSniper
  include AuctionMessageTranslator::PriceSource

  def initialize(auction, sniper_listener, item_id)
    @auction = auction
    @sniper_listener = sniper_listener
    @snapshot = SniperSnapshot.joining(:item_id => item_id)
  end

  def item_id
    @snapshot.item_id
  end

  def auction_closed
    @snapshot = @snapshot.closed
    notify_listener
  end

  def current_price(price, increment, source)
    if (source == FROM_SNIPER)
      @snapshot = @snapshot.winning(:last_price => price)
    else
      bid = price + increment
      @snapshot = @snapshot.bidding(:last_price => price, :last_bid => bid)
      @auction.bid(bid)
    end
    notify_listener
  end


  def notify_listener
    @sniper_listener.sniper_state_changed(@snapshot)
  end
end
