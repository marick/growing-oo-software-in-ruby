$:.unshift  File.expand_path("./lib", File.dirname(__FILE__))
$:.unshift  File.expand_path("./third-party/gem/gems", File.dirname(__FILE__)) # __FILE__ refers to the location of sandbox.rb

$:.unshift  File.expand_path("./third-party/gem/gems/assert2-0.5.5/lib/", File.dirname(__FILE__))

# puts $:

$sandboxed = true
