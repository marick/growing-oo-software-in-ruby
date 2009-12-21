require 'enumerator'

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

  def self.to_event(sol_text)
    pairs = sol_text.split(/[;:]/).collect { | s | s.strip } 
    event = Hash[*pairs]
    # As a quick hack, let's just adorn the object with singleton
    # methods until there's a stronger reason to make an AuctionEvent subclass. 
    def event.type; self['Event']; end
    # Tempted to do some method_missing magic here, but guessing when to 
    # send to_i to the value seems fragile and I don't (yet) want to 
    # define it programmatically. 
    def event.current_price; self['CurrentPrice'].to_i; end
    def event.increment; self['Increment'].to_i; end
    event
  end

  private

  def self.pair(key, value)
    "#{key}: #{value.to_s};"
  end
end
