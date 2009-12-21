class AuctionMessageTranslator
  def initialize(listener)
    @listener = listener
  end

  def process_message(chat, message)
    event = SOLText.to_event(message.body)
    
    case event['Event']
    when 'CLOSE'
      @listener.auction_closed
    when 'PRICE'
      @listener.current_price(event.current_price, event.increment)
    end
  end

end
