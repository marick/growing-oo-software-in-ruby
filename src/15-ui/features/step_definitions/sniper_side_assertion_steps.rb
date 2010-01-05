def text(state)
  SnipersTableModel.status_text(state)
end


Then /^the sniper shows that it.s joining$/ do
  @driver.should be_viewing(:status => text(SniperState::JOINING))
end

Then /^the sniper shows that it.s lost the auction$/ do
  @driver.should be_viewing(:status => text(SniperState::LOST))
end

Then /^the sniper shows that it.s won the auction at a price of (\d+)$/ do | price |
  @driver.should be_viewing(:item_id => @auctions.last_used.item_id,
                                        :status => text(SniperState::WON),
                                        :last_bid => price, 
                                        :most_recent_price => price)
end

Then /^the sniper shows that it.s winning the auction with a bid of (\d+)$/ do | bid |
  @driver.should be_viewing(:item_id => @auctions.last_used.item_id,
                                        :status => text(SniperState::WINNING),
                                        :last_bid => bid, 
                                        :most_recent_price => bid)
end

Then /^the sniper shows that it.s bidding (\d+) to top the previous price$/ do | last_bid |
  most_recent_price = @auctions.last_used.most_recent_price
  @driver.should be_viewing(:item_id => @auctions.last_used.item_id,
                                        :status => text(SniperState::BIDDING),
                                        :last_bid => last_bid, 
                                        :most_recent_price => most_recent_price)
end

