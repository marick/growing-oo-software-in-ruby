
Given /^the auction has started to sell an item$/ do
  @auction = FakeAuctionServer.new(ONE_ITEM)
  @auction.start_selling_item
end

When /^the sniper has started bidding in that auction$/ do
  @application =  AuctionSniperDriver.new(1000)
  @application.start_bidding_in(@auction)
end

Then /^the auction receives the join request from the auction$/ do
  @auction.should have_received_join_request_from_sniper
end

When /^the auction closes$/ do
  pending
#  @auction.announce_closed
end

Then /^the sniper shows that it.s lost the auction$/ do
  pending
#  @application.shows_sniper_has_lost_auction?.should == true
end
