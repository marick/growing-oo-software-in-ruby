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
    @listener.should_receive(:table_changed).with(any).by_default
  end

  should "have enough columns" do 
    assert_equal(Column.num_values, @model.column_count)
  end

  should "notify listener when adding a sniper" do
    assert { @model.row_count == 0 } 
    joining = SniperSnapshot.joining(:item_id => "item123")

    during { 
      @model.add_sniper(joining)
    }.behold! { 
      @listener.should_receive(:table_changed).once.
                with(an_insertion_at_row(0))
    }
    assert { @model.row_count == 1 } 
    assert_row_matches_snapshot(0, joining)
  end

  should "hold snipers in addition order" do
    @listener.should_ignore_missing
    @model.add_sniper(SniperSnapshot.joining(:item_id => "item-0"))
    @model.add_sniper(SniperSnapshot.joining(:item_id => "item-1"))

    assert_equal("item-0", @model.value_at(0, Column::ITEM_ID))
    assert_equal("item-1", @model.value_at(1, Column::ITEM_ID))
  end

  should "set sniper values in columns" do
    @model.add_sniper(SniperSnapshot.joining(:item_id => "item id"))
    during {
      @model.sniper_state_changed(SniperSnapshot.new(:item_id => "item id",
                                                     :last_price => 555,
                                                     :last_bid => 666,
                                                     :state => BIDDING))
    }.behold! {
      @listener.should_receive(:table_changed).once.
                with(a_change_in_row(0))
    }
    assert_model_values(Column::ITEM_ID => "item id",
                        Column::LAST_PRICE => 555,
                        Column::LAST_BID => 666,
                        Column::SNIPER_STATE => SnipersTableModel.status_text(BIDDING))
  end

  # I may have missed it, but as far as I can tell, #goos doesn't call
  # for a test where the listener receives a change in row 1. 
  # That meant that only the end-to-end test motivated the necessary
  # change in sniper_state_changed. Makes me uncomfortable, because 
  # finding that the end-to-end test failed required more digging than 
  # I wanted to do.

  should "update correct row in sniper" do 
    @listener.should_ignore_missing
    @model.add_sniper(SniperSnapshot.joining(:item_id => "item 0"))
    @model.add_sniper(SniperSnapshot.joining(:item_id => "item 1"))

    @model.sniper_state_changed(SniperSnapshot.new(:item_id => "item 1",
                                                   :last_price => 555,
                                                   :last_bid => 666,
                                                   :state => BIDDING))

    assert_equal(555, @model.value_at(1, Column::LAST_PRICE))
  end

  should "raise an exception if there is no matching row" do
    assert_raises(RuntimeError) do
      @model.sniper_state_changed(SniperSnapshot.new(:item_id => "item 1"))
    end

  end

  private

  # matchers

  def an_insertion_at_row(row)
    on { | arg | 
      expected = TableModelEvent.new(@model, row, row,
                                     TableModelEvent::ALL_COLUMNS,
                                     TableModelEvent::INSERT)
      correct_row_changed_event(expected)
    } 
  end

  def a_change_in_row(row)
    on { | arg |  correct_row_changed_event(arg) }
  end

  # random assertions

  def assert_row_matches_snapshot(row, snapshot)
    candidate = @model.row_as_snapshot(row)
    assert { candidate == snapshot } 
  end

  def assert_model_values(hash)
    hash.each do | column, expected | 
      assert_equal(expected, @model.value_at(0, column))
    end
  end


  # misc

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


