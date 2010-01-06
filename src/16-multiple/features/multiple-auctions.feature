Feature: Handling bidding on multiple items at the same time (in multiple auctions)

   Scenario: Sniper bids for multiple items, wins both
      Given the sniper has joined auctions for items 54321 and 65432
      When the first auction reports that another bidder has bid 1000 (increment 98)
      Then it gets back a bid of 1098 from the sniper
        And the sniper shows it's bidding 1098 to top the previous price.

      When the second auction reports that another bidder has bid 500 (increment 21)
      Then it gets back a bid of 521 
       And the sniper shows it's bidding 521 to top the previous price

      When the first auction confirms that the sniper has bid 1098
       And the second auction confirms that the sniper has bid 521
      Then the sniper shows that it's winning both auctions with its last bid.

      When both auctions close
      Then the sniper shows it's won both auctions with its last bid
