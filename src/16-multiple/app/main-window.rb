require 'external/swing'
require 'app/requires'

class MainWindow < JFrame
  APPLICATION_TITLE = "Sniper"
  MAIN_WINDOW_NAME = "Auction Sniper Main"
  SNIPER_TABLE_NAME = "Sniper Status"
  
  def initialize(snipers)
    @snipers = snipers
    self.name = MAIN_WINDOW_NAME
    self.title = APPLICATION_TITLE
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

  def sniper_state_changed(sniper_snapshot)
    @snipers.sniper_state_changed(sniper_snapshot)
  end
end
