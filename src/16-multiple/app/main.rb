require 'pp'
require 'external/xmpp'
require 'external/util'
require 'logger'
require 'app/requires'

module App   # TODO: at some point, this really ought to surround all app code.
  Log = Logger.new($stdout)
  Log.level = Logger::WARN
end

class Main
  AUCTION_RESOURCE = "Auction"
  ITEM_ID_AS_LOGIN = "auction-%s"
  AUCTION_ID_FORMAT = "#{ITEM_ID_AS_LOGIN}@%s/#{AUCTION_RESOURCE}"

  def self.main(hostname, username, password, *item_ids)
    item_id = item_ids[0]
    App::Log.debug("App initializing")
    connection = connection(hostname, username, password)

    main = new
    ui = main.start_user_interface
    disconnect_when_ui_closes(connection, ui)

    item_ids.each do | item_id | 
      main.join_auction(connection, item_id);
    end
  end

  def self.connection(hostname, username, password)
    connection = XMPP::Connection.new(hostname)
    connection.connect
    connection.login(username, password, AUCTION_RESOURCE)
    App::Log.debug("Main connected to XMPP server")
    connection
  end

  def start_user_interface
    App::Log.debug(me("starting user interface"))
    SwingUtilities.invoke_and_wait do 
      # Note: since Main waits for this block to finish, it's 
      # safe to use @ui elsewhere.
      @snipers = SnipersTableModel.new
      @ui = MainWindow.new(@snipers)
    end
    @ui
  end

  def join_auction(connection, item_id)
    safely_add_item_to_model(item_id)
    chat = connection.chat_manager.create_chat(auction_id(item_id, connection),
                                               nil)
    auction = XMPPAuction.new(chat)
    auction_sniper = AuctionSniper.new(auction,
                                       SwingThreadSniperListener.new(@snipers),
                                       item_id)
    translator = AuctionMessageTranslator.new(connection.user, auction_sniper)
    chat.add_message_listener(translator)
    App::Log.debug(me("sending join-auction message"));
    auction.join
  end

  def safely_add_item_to_model(item_id)
    SwingUtilities.invoke_and_wait do 
      @snipers.add_sniper(SniperSnapshot.joining(:item_id => item_id))
    end
  end

  def auction_id(item_id, connection)
    sprintf(AUCTION_ID_FORMAT, item_id, connection.service_name)
  end

  def self.disconnect_when_ui_closes(connection, ui)
    ui.on_window_closed do 
      connection.disconnect
    end
  end
end

