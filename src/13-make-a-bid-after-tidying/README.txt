Instead of having an AuctionEvent class know how to parse message bodies, I
put that behavior into SOLText, which already knows how to make them. That
lets me keep events as hashes (with a little hackery to hide that fact). I
imagine this will change fairly quickly. 
