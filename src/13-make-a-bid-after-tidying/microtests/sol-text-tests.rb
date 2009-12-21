$: << File.expand_path('..' ) unless ENV["sniper_in_rake"]
require 'sandbox'
require 'microtests/testutil'

require 'app/sol-text'

class SOLTextTests < Test::Unit::TestCase
  context "construction" do 
    should "make zero-argument messages" do 
      assert_equal("SOLVersion: 1.1; Event: ZORK;",
                   SOLText.make("ZORK"))
    end

    should "make multi-argument messages" do 
      assert_equal("SOLVersion: 1.1; Event: ZORK; Arg: value;",
                   SOLText.make("ZORK", 'Arg', 'value'))
    end


    should "make arguments into strings" do 
      assert_equal("SOLVersion: 1.1; Event: ZORK; String: 1; Integer: 1;",
                   SOLText.make("ZORK", 'String', '1', Integer, 1))
    end
  end

  context "disassembly" do 
    should "produce a type message" do
      assert_equal 'JOIN', SOLText.to_event(SOLText.join).type
    end

    should "produce values for a PRICE message" do
      event = SOLText.to_event(SOLText.price(3, 33, "some bidder"))
      assert_equal 3, event.current_price
      assert_equal 33, event.increment
    end
  end
end

