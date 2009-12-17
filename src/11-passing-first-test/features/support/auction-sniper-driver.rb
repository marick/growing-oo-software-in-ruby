require 'app/main'
require 'timeout'


class AuctionSniperDriver

  def initialize(timeout_seconds)
    @timeout_seconds = timeout_seconds
    @top_level_frame = MainWindow::MAIN_WINDOW_NAME
  end

  # Method names like "has_sniper_status" work better with the default
  # RSpec, which is clever enough to let you write
  #   @driver.should have_sniper_status MainWindow::STATUS_JOINING
  # and translate into the "has...?" form. It can't do that with
  # "shows...?" (without my having to write custom code).

  def has_sniper_status?(status_text)
    has_eventually?(MainWindow::SNIPER_STATUS_NAME, :text, status_text)
  end

  def stop
  end

  private

  # Our fake version of Swing stores all the widgets indexed by name.
  def has_eventually?(key, accessor, expected)
    Timeout::timeout(@timeout_seconds) do 
      loop do 
        break if JFrame::Widget_map.has_key?(key)
        TestLogger.debug "Driver: No #{key}"
        sleep 0.1
      end

      loop do 
        actual = JFrame::Widget_map[key].send(accessor)
        break if actual == expected
        TestLogger.debug "Driver: #{key} not set to #{expected}. Still #{actual}."
        sleep 0.1
      end
      true
    end
  rescue Timeout::Error
    false
  end
end
