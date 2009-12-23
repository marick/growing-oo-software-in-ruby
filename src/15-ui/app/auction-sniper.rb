require 'app/auction-message-translator'

class AuctionSniper
  include AuctionMessageTranslator::PriceSource
  
  def initialize(auction, sniper_listener)
    @auction = auction
    @sniper_listener = sniper_listener
    @is_winning
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
      @auction.bid(price+increment)
      @sniper_listener.sniper_bidding
    end
  end
end
