Feature: How the sniper works as an auction progresses

   Scenario: Sniper joins auction, but gets no chance to bid before losing
       Given the sniper has joined an ongoing auction
       When the auction closes
       Then the sniper shows that it's lost the auction
      
   Scenario: Sniper makes a higher bid, but loses
       Given the sniper has joined an ongoing auction
       When the auction reports another bidder has bid 1000 with an increment of 98
       Then the sniper shows that it's bidding in the auction
           And the auction receives a bid of 1098 from the sniper

       When the auction closes
       Then the sniper shows that it's lost the auction

   Scenario: Sniper makes a higher bid and wins
       Given the sniper has joined an ongoing auction
        When the sniper responds to a bid of 1000 by rebidding an increment of 98
         Then the auction reports the sniper has bid 1098 with an increment of 97
          And the sniper shows that it's winning the auction

       When the auction closes
       Then the sniper shows that it's won the auction
