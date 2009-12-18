Right now (December 2009) is not a great time for porting the end-to-end test to Ruby on the Mac, at
least if you want an actual working program. I wrestled with plain Ruby, MacRuby, RubyCocoa,
wxwidgets, Cocoa, different flavors of XMPP libraries - all without coming up with something
satisfactory. Finally I decided to fake out both Swing and the XMPP server (though the latter choice
was probably wrong, as I'll explain later). 

Here's what you'll find:

Rakefile: Just type 'rake' to run the end-to-end test.

app/
	In the application code (here) and the test-support code (elsewhere), I tried to make fairly
	close to a 1-1, line-by-line translation of what #goos ends up with at the end of the
	chapter. I tried to explain deviations in the source.

external/
	This contains a fake Swing and a fake XMPP library (and server). 

features/
	This is the domain of the end-to-end tests, which are written with Cucumber and RSpec. 

	basic.feature: This is the test. Again, it's a straight translation of the #goos test.

	step_definitions/
		Cucumber tests are written in pseudo-English. The only file (thus far) in this
		directory contains the translation of the English into Ruby.

	support/
		The step definitions use the same three classes as #goos does. Note also env.rb. 
		If you want to see more logging (to standard output), you can change the level
		there. Note that the test support code uses a different logger than the
		system-under-test. 


# Threading

One potential gotcha is that the logging library uses IO#write, which blocks the calling
thread. Presto! A different order of execution than when logging is turned off. The surest way to
avoid this problem is to have each test step end in wait_for_quiet (defined in env.rb). However,
most steps will end up with the main thread waiting on a Swing event or a message receipt, which
makes the sequencing happen correctly.
