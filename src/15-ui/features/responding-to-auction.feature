Feature: How the sniper works as an auction progresses

   Scenario: Sniper joins auction, but gets no chance to bid before losing
       Given the sniper has joined an ongoing auction
       When the auction closes
       Then the sniper shows that it's lost the auction
      
   Scenario: Sniper makes a higher bid, but loses
       Given the sniper has joined an ongoing auction
       When the auction reports another bidder has bid 1000 (and that the next increment is 98)
       Then the sniper shows that it's bidding 1098 to top the previous price
           And the auction receives a bid of 1098 from the sniper

       When the auction closes
       Then the sniper shows that it's lost the auction

   Scenario: Sniper makes a higher bid and wins
       Given the sniper has joined an ongoing auction
       When the sniper responds to a new price of 1000 (and next increment 98) with the smallest possible bid
       Then the auction reports the sniper has bid 1098 (and that the next increment is 97)
          And the sniper shows that it's winning the auction with a bid of 1098

       When the auction closes
       Then the sniper shows that it's won the auction at a price of 1098
