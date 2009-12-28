require 'external/swing'

module Column
  ITEM_ID = 0
  LAST_PRICE = 1
  LAST_BID = 2
  FINAL = SNIPER_STATUS = 3

  def self.names; ["item id", "last price", "last bid", "status"]; end

  def self.num_values; FINAL+1; end
end


class MainWindow < JFrame
  MAIN_WINDOW_NAME = "Auction Sniper Main"
  SNIPER_TABLE_NAME = "Sniper Status"
  
  STATUS_JOINING = "Joining"
  STATUS_BIDDING = "Bidding"
  STATUS_LOST = "You lose!"
  STATUS_WINNING = "Winning"
  STATUS_WON = "You won!"

  def initialize
    self.name = MAIN_WINDOW_NAME
    @snipers = SnipersTableModel.new
    snipers_table = make_snipers_table
    @snipers.add_table_model_listener(snipers_table)
    fill_content_pane(snipers_table)
  end

  def fill_content_pane(snipers_table)
    # Don't bother with scroll view or content pane setups.
  end
    
  def make_snipers_table
    table = JTable.new(@snipers)
    table.name = SNIPER_TABLE_NAME
    table
  end

  def show_status(status)
    @snipers.show_status(status)
  end

  def sniper_status_changed(sniper_state, status_text)
    @snipers.status_changed(sniper_state, status_text)
  end
end
