Given /^the sniper has joined an ongoing auction$/ do
  steps %Q{
       Given the auction has started to sell an item
           And the sniper has started bidding in that auction
           And the auction has received the join request from the sniper
  }  
end

Given /^the sniper responds to a bid of (\d+) by rebidding an increment of (\d+)$/ do | price, increment |
  steps %Q{ 
      When the auction reports another bidder has bid #{price} with an increment of #{increment}
      Then the sniper shows that it's bidding in the auction
       And the auction receives a bid of #{price.to_i+increment.to_i} from the sniper
  }
end


