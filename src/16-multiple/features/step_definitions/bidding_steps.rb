
When /^the (\w* *)auction reports (.*) has bid (\d+) .and that the next increment is (\d+).$/ do | auction_description, bidder_description, price, increment |
  make_auction_report(auction_description, bidder_description, price, increment)
end

When /^the (\w* *)auction reports (.*) has bid (\d+) .increment (\d+).$/ do | auction_description, bidder_description, price, increment |
  make_auction_report(auction_description, bidder_description, price, increment)
end

When /^the (\w+) auction confirms that the sniper has bid (\d+)$/ do | auction_description, price |
  make_auction_report(auction_description, "the sniper", price, 50)
end



def auction_described_by(auction_description)
  case auction_description.strip
  when ""
    @auctions.last_used
  when "first"
    @auctions[0]
  when "second"
    @auctions[1]
  else
    raise "This is an odd auction description: #{auction_description}"
  end
end

def bidder_described_by(bidder_description)
  return SNIPER_ID if bidder_description == "the sniper"
  bidder_description
end


def make_auction_report(auction_description, bidder_description, price, increment)
  auction = auction_described_by(auction_description)
  bidder = bidder_described_by(bidder_description)
  auction.report_price(price, increment, bidder)
end
