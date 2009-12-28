require 'external/swing'
require 'app/ui'

class SnipersTableModel < JFrameAbstractTableModel
  STARTING_UP = SniperState.new(:item_id => '', :last_price => 0, :last_bid => 0)

  def initialize
    @sniper_state = STARTING_UP
    @status_text = MainWindow::STATUS_JOINING
  end

  def column_count; Column.num_values; end
  def row_count; 1; end

  def value_at(row, column)
    case column
    when Column::ITEM_ID then @sniper_state.item_id
    when Column::LAST_PRICE then @sniper_state.last_price
    when Column::LAST_BID then @sniper_state.last_bid
    when Column:: SNIPER_STATUS then @status_text
    end
  end

  def sniper_status_changed(new_sniper_state, new_status_text)
    @sniper_state = new_sniper_state
    @status_text = new_status_text
    fire_table_rows_updated(0, 0)
  end

  def show_status(new_status_text)
    sniper_status_changed(STARTING_UP, new_status_text)
  end
end
