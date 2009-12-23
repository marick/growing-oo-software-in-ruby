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
    @columns = (0...@model.column_count).collect { Array.new(@model.row_count) }
  end

  def value_at(row, column) 
    @columns[column][row]
  end

  def set_value_at(row, column, newval)
    @columns[column][row] = newval
  end

  def values
    @columns.flatten
  end

  def column_count; @columns.count; end
  def row_count; @columns[0].count; end
end
