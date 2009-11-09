require '../../sandbox' unless $sandboxed
require 'mock-talk'

class AuctionclearMessageTranslatorTest < Test::Unit::TestCase

  def setup
    @listener = flexmock("AuctionEventListener")
    @translator = AuctionMessageTranslator.new(@listener)
  end

  should "notify auction closed when Close message received" do  
    message = Message.new
    message.body = "SOLVersion: 1.1; Event: CLOSE;"
    during {                                       
      @translator.process_message(UNUSED_CHAT, message)       
    }.behold! {
      @listener.should_receive(:auction_closed).once          
    }
  end
end

UNUSED_CHAT='foo'

class AuctionMessageTranslator
  def initialize(listener)
    @listener = listener
  end

  def process_message(arg0, message)
    @listener.auction_closed
  end
end

class Message
  attr_accessor :body
end
