module SniperState
  # I'm using strings instead of integers not because they're what'll be 
  # displayed - that would mush together concerns - but just so they're 
  # clearer in test output (as would be Java enums).

  JOINING = "joining"
  BIDDING = "bidding"
  WINNING = "winning"
  LOST = "lost"
  WON = "won"
end
