Feature: basic sniper behavior

   Scenario: Sniper joins auction, but gets no chance to bid before losing

       Given the auction has started to sell an item
       When the sniper has started bidding in that auction 
       Then the sniper shows that it's joining
         And the auction receives the join request from the sniper

       When the auction closes
       Then the sniper shows that it's lost the auction
      
