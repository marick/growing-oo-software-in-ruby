# Closing the auction and what follows.


When /^the auction closes$/ do
  close_all_auctions
end

When /^both auctions close$/ do
  close_all_auctions
end


def close_all_auctions
  @auctions.each do | auction | 
    auction.announce_closed
  end
end

