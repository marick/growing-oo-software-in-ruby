require 'enumerator'

# I made this string-creating class because I'm bad at typing out
# strings. I especially always forget the ending semicolon. The code
# was complicated enough that I did it with tests. Following #goos,
# I'm not testing each individual *_message method.

class Message
  include Enumerable

  def self.empty_message
    # Used when any random message is to be sent.
    make_message("UNDERSPECIFIED")
  end


  def self.join_message
    make_message("JOIN")
  end

  def self.price_message(price, increment, bidder)
    make_message("PRICE", "CurrentPrice", price, "Increment", increment, "Bidder", bidder)
  end

  def self.bid_message(price)
    make_message("BID", "Price", price)
  end

  def self.make_message(event_name, *args)
    prefix = [message_bit("SOLVersion", "1.1"),
              message_bit("EVENT", event_name)]
    rest = Enumerator.new(args, :each_slice, 2).collect { | key, value | 
      message_bit(key, value)
    }
    (prefix + rest).join(' ')
  end

  private

  def self.message_bit(key, value)
    "#{key}: #{value.to_s};"
  end
end
