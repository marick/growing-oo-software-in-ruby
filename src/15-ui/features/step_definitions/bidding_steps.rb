
When /^the auction reports (.*) has bid (\d+) .and that the next increment is (\d+).$/ do | bidder, price, increment |
  bidder = SNIPER_ID if bidder == "the sniper"  # Could use a transform, but not sure I want this everywhere.
  @auctions.last_used.report_price(price, increment, bidder)
end
