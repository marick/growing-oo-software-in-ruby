Then /^the auction .*receive.* the join request from the sniper$/ do 
  @auctions.last_used.should have_received_join_request_from(SNIPER_XMPP_ID)
end

Then /^the auction receives a bid of (\d+) from the sniper$/ do | bid |
  @auctions.last_used.should have_received_bid bid, SNIPER_XMPP_ID
end
