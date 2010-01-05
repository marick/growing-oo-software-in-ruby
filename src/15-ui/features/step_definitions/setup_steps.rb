# everything up to the point where the sniper has successfully joined.

When /^the auction has started to sell an item$/ do
  start_auctions_for_items([ONE_ITEM])
end

When /^the sniper has started bidding in that auction$/ do
  start_bidding_in_auctions(@auctions)
  start_driver
end

When /^the sniper has joined auctions for items (\d+) and (\d+)$/ do | first_item, second_item |
  start_auctions_for_items(["item-"+first_item, "item-"+second_item])
  start_bidding_in_auctions(@auctions)
  start_driver
end

def start_auctions_for_items(items)
  @auctions = AuctionHolder.new
  items.each do | item |
    @auctions.add_auction_for_item(item)
    @auctions.last_used.start_selling_item
  end
end

def start_bidding_in_auctions(auctions)
  @application = ApplicationRunner.new unless @application
  @application.start_bidding_in(auctions)
end

def start_driver
  @driver = AuctionSniperDriver.new(1) unless @driver
  @driver.should have_title(MainWindow::APPLICATION_TITLE)
  @driver.should have_column_titles
end
