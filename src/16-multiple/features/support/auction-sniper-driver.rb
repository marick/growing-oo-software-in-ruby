require 'app/main'
require 'timeout'

class AuctionSniperDriver
  include Test::Unit::Assertions

  def initialize(timeout_seconds)
    @timeout_seconds = timeout_seconds
  end

  def viewing?(expected)
    has_eventually?(MainWindow::SNIPER_TABLE_NAME, expected) do | widget, expected | 
      has_matching_row?(widget, expected)
    end
  end

  def has_matching_row?(widget, expected)
    widget.rows.each do | row |
      TestLogger.debug("Checking #{row.inspect} for #{expected.inspect}")
      return true if all_expected_values_in_row?(row, expected)
    end
    false
  end

  def all_expected_values_in_row?(row, expected)
    # Following #goos in having table cells contain either integers or 
    # strings. When checking, I check the string representation.
    row = row.collect { | cell | cell.to_s } 
    expected.values.all? do | expected_value |
      row.include? expected_value
    end
  end

  def has_title?(expected)
    main_window.title == expected
  end

  def has_column_titles?
    table = widget(MainWindow::SNIPER_TABLE_NAME)
    (0...Column.num_values).all? do | column | 
      actual = table.column_headers[column]
      expected = Column.names[column]
      if actual != expected
        fail("Column #{column} is #{actual}, not #{expected}.")
      end
    end
    true
  end

  def stop
    main_window.close
  end

  private

  def main_window
    widget(MainWindow::MAIN_WINDOW_NAME)
  end

  def widget(name)
    JFrame::Widget_map[name]
  end

  # Our fake version of Swing stores all the widgets indexed by name.
  def has_eventually?(key, expected, &block)
    Timeout::timeout(@timeout_seconds) do 
      loop do 
        break if JFrame::Widget_map.has_key?(key)
        TestLogger.debug "Driver: No #{key}"
        sleep 0.1
      end

      loop do 
        break if block.call(JFrame::Widget_map[key], expected)
        TestLogger.debug "Driver: #{key} not yet #{expected}."
        sleep 0.1
      end
      true
    end
  rescue Timeout::Error
    flunk "The widget #{key} never contained expected value #{expected.inspect}."
  end
end
