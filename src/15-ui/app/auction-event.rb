require 'app/auction-message-translator'   # I don't like this dependency.

class AuctionEvent
  include AuctionMessageTranslator::PriceSource

  def initialize(hash)
    @hash = hash
  end

  def [](key); @hash[key]; end

  def type; self['Event']; end
  def from?(sniper_id)
    sniper_id == self.bidder ? FROM_SNIPER : FROM_OTHER_BIDDER
  end

  # Tempted to do some method_missing magic here, but guessing when to 
  # send to_i to the value seems fragile and I don't (yet) want to 
  # define it programmatically. 
  def current_price; self['CurrentPrice'].to_i; end
  def increment; self['Increment'].to_i; end
  def bidder; self['Bidder']; end
end
