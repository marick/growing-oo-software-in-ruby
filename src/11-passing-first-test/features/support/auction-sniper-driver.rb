
class AuctionSniperDriver
  include Appscript

  def initialize(timeout_millis)
    @timeout_millis = timeout_millis
  end

  def start_bidding_in(auction)
    env_settings = %Q{SNIPER_HOSTNAME="#{XMPP_HOSTNAME}" SNIPER_ID="#{SNIPER_ID}"  SNIPER_PASSWORD="#{SNIPER_PASSWORD}" SNIPER_ITEM_ID="#{auction.item_id}"}
    puts env_settings
    puts `#{env_settings} open build/Release/#{APP_NAME}.app`
# --args Contents/Resources/rb_main.rb --#{XMPP_HOSTNAME} --#{SNIPER_ID} --#{SNIPER_PASSWORD} --#{auction.item_id}`
    puts "started..."
  end

  def stop
    app(APP_NAME).quit  
  end

private

  def proxy 
    return @proxy if @proxy
    @proxy = app("System Events").processes[APP_NAME]
  end

  def only_window
    proxy.windows[1]
  end

  def sniper_status
    only_window.static_texts[1].value.get
  end

  def shows_sniper_status?(status_text)
    sniper_status == status_text
  end

end
