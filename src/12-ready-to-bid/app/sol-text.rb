require 'enumerator'

# I made this string-creating class because I'm bad at typing out
# strings. I especially always forget the ending semicolon. 

class SOLText
  include Enumerable

  def self.empty
    # Used when any random message is to be sent.
    make("UNDERSPECIFIED")
  end

  def self.join
    make("JOIN")
  end

  def self.close
    make("CLOSE")
  end

  def self.price(price, increment, bidder)
    make("PRICE", "CurrentPrice", price, "Increment", increment, "Bidder", bidder)
  end

  def self.bid(price)
    make("BID", "Price", price)
  end

  def self.make(event_name, *args)
    prefix = [pair("SOLVersion", "1.1"), pair("Event", event_name)]
    rest = Enumerator.new(args, :each_slice, 2).collect { | key, value | 
      pair(key, value)
    }
    (prefix + rest).join(' ')
  end

  private

  def self.pair(key, value)
    "#{key}: #{value.to_s};"
  end
end
