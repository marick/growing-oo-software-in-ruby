module SwingUtilities
  def self.invoke_and_wait(&block)
    thread = Thread.new do
      block.call
    end
    thread.join
  end
  
  def self.invoke_later(&block)
    Thread.new do
      Thread.pass   # This is the "later" part.
      block.call
    end
  end
end

class JFrame
  Widget_map = {}

  def name=(name)
    Widget_map[name] = self
  end

  def add(widget)
  end

  def close
    Widget_map.clear
    @on_window_closed_callback.call
  end

  def on_window_closed(&block)
    @on_window_closed_callback = block
  end

end

class JLabel < JFrame
  attr_accessor :text

  def initialize(text)
    @text = text
  end
end

class JFrameAbstractTableModel
  def fire_table_rows_updated(row, column)
    table.set_value_at(row, column, self.value_at(row, column))
  end
end


class JTable < JFrame
  def initialize(model)
    @model = model
    @model.table = self
    @rows = (0...@model.row_count).collect { Array.new(@model.column_count) }
  end

  def value_at(row, column) 
    @rows[row][column]
  end

  def set_value_at(row, column, newval)
    @rows[row][column] = newval
  end

  def values
    @rows.flatten
  end

  def row_count; @rows.count; end
  def column_count; @rows[0].count; end
end
