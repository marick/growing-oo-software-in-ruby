
Given /^the auction has started to sell an item$/ do
  @auction = FakeAuctionServer.new(ONE_ITEM)
  @auction.start_selling_item
  wait_for_quiet
end

When /^the sniper has started bidding in that auction$/ do
  @application =  ApplicationRunner.new
  @application.start_bidding_in(@auction)
  wait_for_quiet
end

Then /^the sniper shows that it.s joining$/ do
  @driver = AuctionSniperDriver.new(1)
  @driver.should have_sniper_status(MainWindow::STATUS_JOINING)
  wait_for_quiet
end

Then /^the auction receives the join request from the sniper$/ do
  @auction.should have_received_join_request_from_sniper
  wait_for_quiet
end

When /^the auction closes$/ do
  @auction.announce_closed
  wait_for_quiet
end

Then /^the sniper shows that it.s lost the auction$/ do
  @driver.should have_sniper_status(MainWindow::STATUS_LOST)
  wait_for_quiet
end
