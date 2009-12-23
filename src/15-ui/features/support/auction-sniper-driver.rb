require 'app/main'
require 'timeout'

class AuctionSniperDriver
  include Test::Unit::Assertions

  def initialize(timeout_seconds)
    @timeout_seconds = timeout_seconds
  end

  # Method names like "has_sniper_status" work better with the default
  # RSpec, which is clever enough to let you write
  #   @driver.should have_sniper_status MainWindow::STATUS_JOINING
  # and translate into the "has...?" form. It can't do that with
  # "shows...?" (without my having to write custom code).

  def has_sniper_status?(status_text)
    has_eventually?(MainWindow::SNIPER_TABLE_NAME, status_text) do | widget, expected | 
      widget.values.include? expected
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
    flunk "The widget #{key} never contained expected value #{expected}."
  end
end
