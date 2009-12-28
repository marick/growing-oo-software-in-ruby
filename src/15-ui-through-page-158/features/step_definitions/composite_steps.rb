Given /^the sniper has joined an ongoing auction$/ do
  steps %Q{
       Given the auction has started to sell an item
           And the sniper has started bidding in that auction
           And the auction has received the join request from the sniper
  }  
end

Given /^the sniper responds to a new price of (\d+) .and next increment (\d+). with the smallest possible bid$/ do | price, increment |
  sniper_bid = price.to_i+increment.to_i
  steps %Q{ 
      When the auction reports another bidder has bid #{price} (and that the next increment is #{increment})
      Then the sniper shows that it.s bidding #{sniper_bid} to top the previous price
       And the auction receives a bid of #{price.to_i+increment.to_i} from the sniper
  }
end


