$: << '..' unless $in_rake
require '../../../sandbox' unless $sandboxed # Why can't go relative to "..", I don't know.
require 'microtests/testutil'

require 'app/message'

class MessageTests < Test::Unit::TestCase
  should "construct zero-argument messages" do 
    assert_equal("SOLVersion: 1.1; EVENT: ZORK;",
                 Message.make_message("ZORK"))
  end

  should "construct multi-argument messages" do 
    assert_equal("SOLVersion: 1.1; EVENT: ZORK; Arg: value;",
                 Message.make_message("ZORK", 'Arg', 'value'))
  end


  should "make arguments into strings" do 
    assert_equal("SOLVersion: 1.1; EVENT: ZORK; String: 1; Integer: 1;",
                 Message.make_message("ZORK", 'String', '1', Integer, 1))
  end
end

