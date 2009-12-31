require 'external/swing'
require 'app/sniper-state'
require 'app/sniper-snapshot'
require 'app/main-window'
require 'app/column'

class SnipersTableModel < JFrameAbstractTableModel
  include SniperState

  STATUS_TEXT = { 
    # Why keep those constants in MainWindow?
    JOINING => "Joining",
    BIDDING => "Bidding",
    LOST => "Lost",
    WINNING => "Winning",
    WON => "Won",
  }

  def self.status_text(state)
    SnipersTableModel::STATUS_TEXT[state]
  end

  def initialize
    @snapshot = nil
    @status_text = STATUS_TEXT[JOINING]
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
end
