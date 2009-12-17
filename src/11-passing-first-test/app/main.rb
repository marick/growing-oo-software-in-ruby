require 'ostruct'
require 'pp'
require 'external/swing'
require 'external/xmpp'
require 'external/util'
require 'logger'

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
    chat = connection.chat_manager.create_chat(auction_id(item_id, connection),
                                               MainMessageListener.new(@ui))
    # I passed in a MainMessageListener instead of a block because I imagine 
    # there will eventually be more more than one method on it. (A block is just
    # an object with a single method: "do whatever you do".)
    Log.info(me("sending join-auction message"));
    chat.send_message(XMPP::Message.new)

    # In #goos, there's some code that assigns chat to an instance
    # variable (notToBeGCd) to keep it from being garbage collected. I don't think
    # that's needed with the fake XMPP implementation.
  end

  def auction_id(item_id, connection)
    sprintf(AUCTION_ID_FORMAT, item_id, connection.service_name)
  end

  class MainMessageListener
    # We have to pass the MainWindow object in Ruby "inner" classes don't see their
    # enclosing class's instance variables.
    def initialize(ui)
      @ui = ui
    end

    def process_message(chat, message)
      Log.debug(me("received message"))
      SwingUtilities.invoke_later do
        Log.debug(me("Getting ready to show #{MainWindow::STATUS_LOST}"))
        @ui.show_status(MainWindow::STATUS_LOST)
      end
    end
  end
end

class MainWindow < JFrame
  MAIN_WINDOW_NAME = "Auction Sniper Main"
  SNIPER_STATUS_NAME = "Sniper Status"
  
  STATUS_JOINING = "Joining"
  STATUS_LOST = "You lose!"

  def initialize
    name = MAIN_WINDOW_NAME
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
