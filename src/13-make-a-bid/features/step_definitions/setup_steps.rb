# everything up to the point where the sniper has successfully joined.

When /^the auction has started to sell an item$/ do
  @auction = FakeAuctionServer.new(ONE_ITEM)
  @auction.start_selling_item
end

When /^the sniper has started bidding in that auction$/ do
  @application =  ApplicationRunner.new
  @application.start_bidding_in(@auction)
  @driver = AuctionSniperDriver.new(1)
end


