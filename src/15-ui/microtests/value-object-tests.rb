$: << File.expand_path('..' ) unless ENV["sniper_in_rake"]
require 'sandbox'
require 'microtests/testutil'

require 'app/value-object'

class ValueObjectTests < Test::Unit::TestCase
  Pair = ValueObjectClass(:x, :y)

  should "create an instance with keyword arguments" do 
    pair = Pair.new(:x => 1, :y => 2)
    assert { pair.x == 1 }
    assert { pair.y == 2 }
  end

  should "throw exception on attempt to call setter" do 
    pair = Pair.new(:x => 1, :y => 2)
    assert_raises(RuntimeError) do
      pair.x = 33
    end
  end

  should "require all values to be initialized on instance creation" do 
    assert_raises(RuntimeError) do 
      pair = Pair.new(:x => 1)
    end
  end

  should "define equality as attribute equality" do 
    original = Pair.new(:x => 1, :y => 2)
    assert { original == Pair.new(:x => 1, :y => 2) }
    deny { original == Pair.new(:x => 1, :y => :SOMETHING_ELSE) }
    deny { original == Pair.new(:x => :SOMETHING_ELSE, :y => 2) }
  end
end
