
require 'constants'
require 'xmpp4r-simple'

ARG_HOSTNAME = ENV["SNIPER_HOSTNAME"] || "localhost"
ARG_USERNAME =  ENV["SNIPER_ID"] || "sniper"
ARG_PASSWORD = ENV["SNIPER_PASSWORD"] || "sniper"
ARG_ITEM_ID = ENV["SNIPER_ITEM_ID"] || "item-54321"

AUCTION_RESOURCE = "Auction"

class Application < NSObject
  include Jabber

  def applicationDidFinishLaunching(notification)
    jid_string = "#{ARG_USERNAME}@#{ARG_HOSTNAME}/#{AUCTION_RESOURCE}"
    puts jid_string
    @connection = Jabber::Simple.new(jid_string, ARG_PASSWORD)
  end
  
  def start
    puts "==== Ready for JID"

    jid_string = "#{ARG_USERNAME}@localhost/#{AUCTION_RESOURCE}"
    puts jid_string
    jid = JID::new(jid_string)
    puts "JID: #{jid}"
    cl = Client::new(jid)
    result = cl.connect
    puts "connection result = #{result}"
    result = cl.auth(ARG_PASSWORD)
    puts "auth result: #{result}"


    puts "==== Starting..."

    application :name => APP_NAME do |app|
      app.delegate = self
      window :frame => [100, 100, 500, 500], :title => APP_NAME do |win|
        win << label(:text => STATUS_JOINING, :layout => {:start => false})
        win.will_close { exit }
      end
    end

  end
  
end

# Application.new.start
