require 'app/main'
require 'timeout'

class AuctionSniperDriver
  include Test::Unit::Assertions

  def initialize(timeout_seconds)
    @timeout_seconds = timeout_seconds
  end

  def has_sniper_status?(expected)
    has_eventually?(MainWindow::SNIPER_TABLE_NAME, expected) do | widget, expected | 
      has_matching_row?(widget, expected)
    end
  end

  def has_matching_row?(widget, expected)
    widget.rows.each do | row |
      return true if all_expected_values_in_row?(row, expected)
    end
    false
  end

  def all_expected_values_in_row?(row, expected)
    expected.values.all? do | expected_value |
      row.include? expected_value
    end
  end

  def stop
    JFrame::Widget_map[MainWindow::MAIN_WINDOW_NAME].close
  end

  private

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
