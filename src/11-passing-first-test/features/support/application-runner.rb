require 'features/support/constants'

SNIPER_ID = 'sniper'
SNIPER_PASSWORD = 'sniper'


class ApplicationRunner
  def start_bidding_in(auction)
    thread = Thread.new do
      begin
        Main.main(XMPP_HOSTNAME, SNIPER_ID, SNIPER_PASSWORD, auction.item_id)
      rescue Exception => ex 
        puts ex.backtrace
      end
    end
  end

  def stop
  end
end

