class AuctionMessageTranslator
  module PriceSource     # Q: Shouldn't this be in AuctionEvent?
    FROM_SNIPER = "From sniper"
    FROM_OTHER_BIDDER = "From other bidder"
  end

  def initialize(sniper_id, listener)
    @sniper_id = sniper_id
    @listener = listener
  end

  def process_message(chat, message)
    event = SOLText.to_event(message.body)
    
    case event['Event']
    when 'CLOSE'
      @listener.auction_closed
    when 'PRICE'
      @listener.current_price(event.current_price, event.increment,
                              event.from?(@sniper_id))
    end
  end

end
