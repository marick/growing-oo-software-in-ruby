class AuctionSniper
  def initialize(auction, sniper_listener)
    @auction = auction
    @sniper_listener = sniper_listener
  end

  def auction_closed
    @sniper_listener.sniper_lost
  end

  def current_price(price, increment)
    @auction.bid(price+increment)
    @sniper_listener.sniper_bidding
  end
end
