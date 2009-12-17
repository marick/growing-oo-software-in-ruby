require 'features/support/constants'

SNIPER_ID = 'sniper'
SNIPER_PASSWORD = 'sniper'

# In #goos, the ApplicationRunner creates the AuctionSniperDriver and
# also has methods to query the UI (by calling the driver). I didn't
# see why the tests shouldn't create the AuctionSniperDriver as well
# as the ApplicationRunner, and why they shouldn't query the Driver
# directly, so that's what I did. That makes this class have only the
# responsibility of launching the app (in a thread instead of in its
# own process).

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
    # In the fake Swing UI, there's nothing to dispose. 
  end
end

