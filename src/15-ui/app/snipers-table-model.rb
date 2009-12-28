require 'external/swing'
require 'app/sniper-state'
require 'app/sniper-snapshot'
require 'app/main-window'
require 'app/column'

class SnipersTableModel < JFrameAbstractTableModel
  STATUS_TEXT = { 
    # Why keep those constants in MainWindow?
    SniperState::JOINING => MainWindow::STATUS_JOINING,
    SniperState::BIDDING => MainWindow::STATUS_BIDDING,
    SniperState::LOST => MainWindow::STATUS_LOST,
    SniperState::WINNING => MainWindow::STATUS_WINNING,
    SniperState::WON => MainWindow::STATUS_WON
  }
    

  STARTING_UP = SniperSnapshot.new(:item_id => '', :last_price => 0, :last_bid => 0,
                                   :state => SniperState::JOINING)

  def initialize
    @snapshot = STARTING_UP
    @status_text = MainWindow::STATUS_JOINING
  end

  def column_count; Column.num_values; end
  def row_count; 1; end

  def value_at(row, column)
    case column
    when Column::ITEM_ID then @snapshot.item_id
    when Column::LAST_PRICE then @snapshot.last_price
    when Column::LAST_BID then @snapshot.last_bid
    when Column::SNIPER_STATE then @status_text
    end
  end

  def sniper_state_changed(new_snapshot)
    @snapshot = new_snapshot
    @status_text = STATUS_TEXT[@snapshot.state]
    fire_table_rows_updated(0, 0)
  end

  def show_status(new_status_text)
    sniper_status_changed(STARTING_UP, new_status_text)
  end
end
