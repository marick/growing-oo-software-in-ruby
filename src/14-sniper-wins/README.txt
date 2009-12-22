The way all the features start the same way was starting to
annoy me, so I used Cucumber's composite steps feature to
combine them. The pattern is that once one scenario
introduces a series of steps, the next one uses a composite
step that collects them.

I created an AuctionEvent class like the one in #goos, pulling out the code I just
put into SOLText.

I keep trying to find a good name for the feature file. This
time it's responding-to-auction.feature. 
