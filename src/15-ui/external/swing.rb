require 'logger'

module SwingUtilities
  Log = Logger.new($stdout)
  Log.level = Logger::WARN

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
  attr_accessor :title

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
  def add_table_model_listener(listener)
    @listener = listener  # Only one so far.
  end

  def fire_table_rows_updated(first_row, last_row)
    @listener.table_changed(TableModelEvent.new(self, first_row))
  end
end

class TableModelEvent
  attr_reader :model, :row
  def initialize(model, row)
    @model = model
    @row = row
  end
end

class JTable < JFrame
  attr_accessor :rows, :column_headers

  def initialize(model)
    @rows = (0...model.row_count).collect do 
      Array.new(model.column_count, "")
    end
    set_column_headers(model)
  end

  def value_at(row, column) 
    @rows[row][column]
  end

  def set_value_at(row, column, newval)
    @rows[row][column] = newval
  end

  def set_column_headers(model)
    @column_headers = (0...model.column_count).inject([]) do | so_far, column | 
      so_far << model.column_name(column)
    end
  end

  def table_changed(event)
    model = event.model
    row = event.row
    (0...Column.num_values).each do | column |
      set_value_at(row, column, model.value_at(row, column))
    end

    if SwingUtilities::Log.info?
      hash = {}
      (0...Column.num_values).each do | column |
        hash[@column_headers[column]] = value_at(row, column)
      end
      SwingUtilities::Log.info("Updated row #{row}: #{hash.inspect}")
    end
  end
end
