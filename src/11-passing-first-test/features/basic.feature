Feature: basic sniper behavior

   Scenario: Sniper joins auction until auction closes

       Given the auction has started to sell an item
       When the sniper has started bidding in that auction 
       Then the auction receives the join request from the auction

       When the auction closes
       Then the sniper shows that it's lost the auction
      
