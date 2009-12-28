The strategy I started in the last chapter...

   The way all the features start the same way was starting to
   annoy me, so I used Cucumber's composite steps feature to
   combine them. The pattern is that once one scenario
   introduces a series of steps, the next one uses a composite
   step that collects them.

... conflicted with the #goos strategy of having only one
test fail. I decided to keep up with it, which means that
two tests fail here, rather than only the last one. The
failures are the same, though.
