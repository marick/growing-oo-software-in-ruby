require 'external/swing'
require 'app/requires'

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

  def sniper_state_changed(sniper_snapshot)
    @snipers.status_changed(sniper_snapshot)
  end
end
