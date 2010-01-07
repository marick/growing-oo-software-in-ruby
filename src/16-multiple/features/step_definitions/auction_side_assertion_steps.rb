# In #goos, these assertions use the fully-qualified name
# (sniper@localhost/Auction). (I think). My fake XMPP stores the 
# userid as the participant, so I'll test for it here rather than change it.

Then /^the auction .*receive.* the join request from the sniper$/ do 
  @auctions.last_used.should have_received_join_request_from(SNIPER_ID)
end

Then /^the auction receives a bid of (\d+) from the sniper$/ do | bid |
  got_bid(bid)
end

Then /^it gets back a bid of (\d+) from the sniper$/ do | bid | 
  got_bid(bid)
end

Then /^it gets back a bid of (\d+)$/ do | bid | 
  got_bid(bid)
end



def got_bid(bid)
  @auctions.last_used.should have_received_bid bid, SNIPER_ID
end
