
When /^the auction reports (.*) has bid (\d+) with an increment of (\d+)$/ do | bidder, price, increment |
  @auction.report_price(price, increment, bidder)
end




