$: << File.expand_path('..' ) unless ENV["sniper_in_rake"]
require 'sandbox'
require 'microtests/testutil'

require 'app/sol-text'

class SOLTextTests < Test::Unit::TestCase
  should "construct zero-argument messages" do 
    assert_equal("SOLVersion: 1.1; Event: ZORK;",
                 SOLText.make("ZORK"))
  end

  should "construct multi-argument messages" do 
    assert_equal("SOLVersion: 1.1; Event: ZORK; Arg: value;",
                 SOLText.make("ZORK", 'Arg', 'value'))
  end


  should "make arguments into strings" do 
    assert_equal("SOLVersion: 1.1; Event: ZORK; String: 1; Integer: 1;",
                 SOLText.make("ZORK", 'String', '1', Integer, 1))
  end
end

