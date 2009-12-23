require 'ostruct'
require 'pp'
require 'external/swing'
require 'external/xmpp'
require 'external/util'
require 'logger'
require 'app/sol-text'
require 'app/auction-message-translator'
require 'app/xmpp-auction'
require 'app/auction-sniper'
require 'app/sniper-state-displayer'

class Main
  Log = Logger.new($stdout)
  Log.level = Logger::WARN
  
  ARG_HOSTNAME = 0
  ARG_USERNAME = 1
  ARG_PASSWORD = 2
  ARG_ITEM_ID = 3

  AUCTION_RESOURCE = "Auction"
  ITEM_ID_AS_LOGIN = "auction-%s"
  AUCTION_ID_FORMAT = "#{ITEM_ID_AS_LOGIN}@%s/#{AUCTION_RESOURCE}"

  def self.main(*args)
    Log.info("App initializing")
    main = new
    main.join_auction(connection(args[ARG_HOSTNAME], args[ARG_USERNAME], args[ARG_PASSWORD]),
                      args[ARG_ITEM_ID]);
  end

  def self.connection(hostname, username, password)
    connection = XMPP::Connection.new(hostname)
    connection.connect
    connection.login(username, password, AUCTION_RESOURCE)
    Log.info("Main connected to XMPP server")
    connection
  end

  def initialize
    start_user_interface
  end

  def start_user_interface
    Log.info(me("starting user interface"))
    SwingUtilities.invoke_and_wait do 
      # Note: since Main waits for this block to finish, it's 
      # safe to use @ui elsewhere.
      @ui = MainWindow.new
    end
  end

  def join_auction(connection, item_id)
    disconnect_when_ui_closes(connection)

    chat = connection.chat_manager.create_chat(auction_id(item_id, connection),
                                               nil)
    auction = XMPPAuction.new(chat)
    auction_sniper = AuctionSniper.new(auction, SniperStateDisplayer.new(@ui))
    translator = AuctionMessageTranslator.new(connection.user, auction_sniper)
    chat.add_message_listener(translator)
    Log.info(me("sending join-auction message"));
    auction.join
  end

  def auction_id(item_id, connection)
    sprintf(AUCTION_ID_FORMAT, item_id, connection.service_name)
  end

  def disconnect_when_ui_closes(connection)
    @ui.on_window_closed do 
      connection.disconnect
    end
  end
end

class MainWindow < JFrame
  MAIN_WINDOW_NAME = "Auction Sniper Main"
  SNIPER_STATUS_NAME = "Sniper Status"
  
  STATUS_JOINING = "Joining"
  STATUS_BIDDING = "Bidding"
  STATUS_LOST = "You lose!"
  STATUS_WINNING = "Winning"
  STATUS_WON = "You won!"

  def initialize
    self.name = MAIN_WINDOW_NAME
    @sniper_status = create_label(STATUS_JOINING)
    add(@sniper_status)
  end
    
  def create_label(initial_text)
    label = JLabel.new(initial_text)
    label.name = SNIPER_STATUS_NAME
    label
  end

  def show_status(status)
    @sniper_status.text = status
  end
end
