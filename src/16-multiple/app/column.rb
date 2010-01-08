module Column
  ITEM_ID = 0
  LAST_PRICE = 1
  LAST_BID = 2
  FINAL = SNIPER_STATE = 3

  SNAPSHOT_READERS = {
    ITEM_ID => lambda { | snapshot | snapshot.item_id }, # Use &: if past Ruby 1.8.6
    LAST_PRICE => lambda { | snapshot | snapshot.last_price },
    LAST_BID => lambda { | snapshot | snapshot.last_bid },

    # I hate hate hate that Column uses SnipersTableModel.status_text. 
    # Did that come from #goos? 
    SNIPER_STATE => lambda { | snapshot | SnipersTableModel.status_text(snapshot.state) }, 
  }

  # I'm keeping the text "status" because I think that's more user-friendly
  # than "state".
  def self.names; ["Item", "Last Price", "Last Bid", "Status"]; end

  def self.num_values; FINAL+1; end

  def self.value_in(snapshot, index)
    SNAPSHOT_READERS[index].call(snapshot)
  end

end
