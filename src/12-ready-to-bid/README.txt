I've put the unit tests in the directory microtests. I use the flexmock
mocking framework which is similar to older versions of JMock. I use blocks
to put the expectation after the code that should cause it to be met. I
think that reads more naturally. So, a test body like 

   context.checking(new Expectations() {{
      oneOf(listener).auctionClosed
   }});
   ...
   translator.processMessage(...)

reads like this:

   during {
       translator.process_message(...)
   }.behold! {
       listener.should_receive(:auction_closed).once
   }

I further use the Shoulda gem to give me RSpec test naming and nested
contexts. So a test that #goos names:

   @Test public void
   notifiesAuctionClosesWhenCloseMessageReceived

can be named

   should "notify its listener the auction is closed when the 'close' message is received" do

I'm not using RSpec itself because I'm not wild about heavily-English
syntax for assertions, not in microtests written for programmers to read.

Finally, I use assert{2.0}, which lets you write assertions like this:

      assert { message.body == AuctionMessage.join_message } 

The nice thing about an assert{2.0} assertion failure is that it prints out
values of subexpressions. So in the above case, it would print the values
of:
	message
	message.body
	AuctionMessage
	AuctionMessage.join_message
        message.body == AuctionMessage.join_message	

Seeing those intermediate values can be helpful. 

I occasionally fall back to assert_equal for two reasons:
1)  I'm not wild about ==-expressions that extend over multiple lines, and
    your IDE or editor probably auto-aligns arguments to assert_equal
    better than it formats multi-line equalities.
2) Apple ships 1.8.7 on Snow Leopard. 1.8.7 doesn't handle assert2.0 printing
   right. All you get is this message:
   	  assert{  }	--> false - should pass

   So if I really want to see the failure message, I can't use assert{2.0}.



==== RANDOM NOTES

I found myself confused at least twice by the difference between an XMPP
message and the formatted body of such a message (which is also called a
message in #goos). So I've started referring to the latter as a SOLText,
though I may not have made the substitution consistently.

To run tests, use either 
   % rake        # To run only microtests (unit tests)
or
   % rake cucumber     # runs both, microtests first.
