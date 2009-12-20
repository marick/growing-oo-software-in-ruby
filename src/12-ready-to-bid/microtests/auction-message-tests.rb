$: << File.expand_path('..' ) unless ENV["sniper_in_rake"]
require 'sandbox'
require 'microtests/testutil'

require 'app/auction-message'

class AuctionAuctionMessageTests < Test::Unit::TestCase
  should "construct zero-argument messages" do 
    assert_equal("SOLVersion: 1.1; Event: ZORK;",
                 AuctionMessage.make_message("ZORK"))
  end

  should "construct multi-argument messages" do 
    assert_equal("SOLVersion: 1.1; Event: ZORK; Arg: value;",
                 AuctionMessage.make_message("ZORK", 'Arg', 'value'))
  end


  should "make arguments into strings" do 
    assert_equal("SOLVersion: 1.1; Event: ZORK; String: 1; Integer: 1;",
                 AuctionMessage.make_message("ZORK", 'String', '1', Integer, 1))
  end
end

