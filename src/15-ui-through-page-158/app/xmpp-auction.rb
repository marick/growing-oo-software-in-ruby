class XMPPAuction
  def initialize(chat)
    @chat = chat
  end

  def bid(amount)
    send_message(SOLText.bid(amount))
  end

  def join
    send_message(SOLText.join)
  end

  def send_message(text)
    @chat.send_message(text)
  rescue Exception => ex
    puts ex.backtrace
  end
end
