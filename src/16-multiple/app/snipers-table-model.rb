require 'external/swing'
require 'app/sniper-state'
require 'app/sniper-snapshot'
require 'app/main-window'
require 'app/column'

class SnipersTableModel < JFrameAbstractTableModel
  include SniperState

  STATUS_TEXT = { 
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
    @snapshots = []
  end

  def column_count; Column.num_values; end
  def row_count; @snapshots.size; end
  def row_as_snapshot(row); @snapshots[row]; end

  def value_at(row, column)
    Column.value_in(@snapshots[row], column)
  end

  def column_name(column)
    Column.names[column]
  end

  def add_sniper(snapshot)
    next_row = @snapshots.length
    @snapshots << snapshot
    fire_table_rows_inserted(next_row, next_row)
  end

  def find_row_matching(snapshot)
    match = @snapshots.find do | candidate |
      candidate.is_for_same_item_as?(snapshot)
    end
    throw "Programmer Error: Cannot find match for #{snapshot.inspect}" unless match
    match
  end

  def sniper_state_changed(new_snapshot)
    index = @snapshots.index(find_row_matching(new_snapshot))
    @snapshots[index] = new_snapshot
    @snapshot = new_snapshot
    fire_table_rows_updated(index, index)
  end
end
