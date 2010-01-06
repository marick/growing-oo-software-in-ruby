$: << File.expand_path('..' ) unless ENV["sniper_in_rake"]
require 'sandbox'
require 'microtests/testutil'

require 'app/column'
require 'app/sniper-snapshot'

class ColumnTests < Test::Unit::TestCase
  should "extract right columns out of a snapshot"  do 
    snapshot = SniperSnapshot.new(:item_id => "an item",
                                  :last_price => "a price",
                                  :last_bid => "a bid",
                                  :state => "NOT USED IN THIS TEST")

    assert { Column.value_in(snapshot, Column::ITEM_ID) == "an item" }
    assert { Column.value_in(snapshot, Column::LAST_PRICE) == "a price" }
    assert { Column.value_in(snapshot, Column::LAST_BID) == "a bid" }
  end


  should "translate state symbols into status names" do 
    snapshot = SniperSnapshot.joining(:item_id => :unused)

    assert { Column.value_in(snapshot, Column::SNIPER_STATE) == "Joining" }
  end

  should "provide column names" do
    assert { Column.names[Column::ITEM_ID] == "Item" } 
    assert { Column.names[Column::LAST_PRICE] == "Last Price" } 
    assert { Column.names[Column::LAST_BID] == "Last Bid" } 
    assert { Column.names[Column::SNIPER_STATE] == "Status" } 
  end

end   
