require 'delegate'

class AuctionHolder < DelegateClass(Array)

  attr_reader :last_index

  def initialize
    @auctions = []
    super(@auctions)
  end

  def add_auction_for_item(item_id)
    auction = FakeAuctionServer.new(item_id)
    @auctions << auction
    @last_index = @auctions.length - 1
  end

  # Could use this class itself, as it quacks like an Array, but this
  # seems more clear.
  def all   
    @auctions
  end

  def [](index)
    @last_index = index
    super
  end

  def []=(index, new_value)
    @last_index = index
    super
  end

  def last_used
    @auctions[@last_index]
  end
end
