require 'app/value-object'
require 'app/sniper-state'

class SniperSnapshot < ValueObjectClass(:item_id, :last_price, :last_bid, :state)
  include SniperState

  def self.joining(values)
    new(:item_id => values[:item_id], :last_price => 0, :last_bid => 0,
        :state => SniperState::JOINING)
  end
  def joining(values); self.class.joining(values); end

  def bidding(new_values)
    clone.move_to(BIDDING).merge!(:last_price => new_values[:last_price],
                                  :last_bid => new_values[:last_bid])
  end

  def winning(new_values)
    clone.move_to(WINNING).merge!(:last_price => new_values[:last_price])
  end

  # Can't do #goos weird @override thing. Ruby is so primitive.
  def closed
    if state == WINNING
      clone.move_to(WON)
    else
      clone.move_to(LOST)
    end
  end

  def is_for_same_item_as?(other)
    self.item_id == other.item_id
  end

  def move_to(state)
    self.clone.merge!(:state => state)
  end

  def merge!(hash)
    hash.each do | key, value |
      self[key] = value
    end
    self
  end
end
