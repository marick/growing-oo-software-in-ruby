$: << File.expand_path('..' ) unless ENV["sniper_in_rake"]
require 'sandbox'
require 'microtests/testutil'

require 'app/snipers-table-model'

class SnipersTableModelTests < Test::Unit::TestCase
  include SniperState

  def setup
    @listener = flexmock("table model listener")
    @model = SnipersTableModel.new
    @model.add_table_model_listener(@listener)
  end

  should "have enough columns" do 
    assert_equal(Column.num_values, @model.column_count)
  end

  should "set sniper values in columns" do
    during {
      @model.sniper_state_changed(SniperSnapshot.new(:item_id => "item id",
                                                     :last_price => 555,
                                                     :last_bid => 666,
                                                     :state => BIDDING))
    }.behold! {
      @listener.should_receive(:table_changed).once.
                with( on { | arg |  correct_row_changed_event(arg) })
    }
    assert_model_values(Column::ITEM_ID => "item id",
                        Column::LAST_PRICE => 555,
                        Column::LAST_BID => 666,
                        Column::SNIPER_STATE => SnipersTableModel.status_text(BIDDING))
  end


  def assert_model_values(hash)
    hash.each do | column, expected | 
      assert_equal(expected, @model.value_at(0, column))
    end
  end

  def correct_row_changed_event(actual_event)
    same_properties_as?(actual_event, TableModelEvent.new(@model, 0))
  end

  def same_properties_as?(actual, expected)
    assert_equal(expected.instance_variables.sort,
                 actual.instance_variables.sort)
    expected.instance_variables do | var | 
      assert_equal(expected.instance_variable_get(var),
                   actual.instance_variable_get(var))
    end
  end
end


