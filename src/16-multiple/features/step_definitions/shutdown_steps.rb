# Closing the auction and what follows.


When /^the auction closes$/ do
  @auctions.each do | auction | 
    auction.announce_closed
  end
end

