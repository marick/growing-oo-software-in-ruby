class Auction
  def initialize(chat)
    @chat = chat
  end

  def bid(amount)
    @chat.send_message(SOLText.bid(amount))
  end
end
