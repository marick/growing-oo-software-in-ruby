Feature: Ways to lose an auction

   Scenario: Sniper joins auction, but gets no chance to bid before losing

       Given the auction has started to sell an item
       When the sniper has started bidding in that auction 
       Then the sniper shows that it's joining
         And the auction receives the join request from the sniper

       When the auction closes
       Then the sniper shows that it's lost the auction
      
   Scenario: Sniper makes a higher bid, but loses
       Given the auction has started to sell an item
           And the sniper has started bidding in that auction
           And the auction has received the join request from the sniper
       When the auction reports another bidder has bid 1000 with an increment of 98
       Then the sniper shows that it's bidding in the auction
           And the auction receives a bid of 1098 from the sniper

       When the auction closes
       Then the sniper shows that it's lost the auction
