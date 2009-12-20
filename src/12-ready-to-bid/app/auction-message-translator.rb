class AuctionMessageTranslator
  def initialize(listener)
    @listener = listener
  end

  def process_message(chat, message)
    # Following code will, I expect, soon belong with SOLText or its successor.
    # For now, it's as written in #goos.
    event = unpack_event_from(message.body) 
    
    case event['Event']
    when 'CLOSE'
      @listener.auction_closed
    when 'PRICE'
      @listener.current_price(event['CurrentPrice'].to_i, event['Increment'].to_i)
    end
  end

  def unpack_event_from(sol_text)
    # Note: Ruby 1.8.6 doesn't have the &:message hack built in, so I use this
    # way-less-cool form of collect.
    pairs = sol_text.split(/[;:]/).collect { | s | s.strip } 
    Hash[*pairs]
  end
end
