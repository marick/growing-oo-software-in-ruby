require 'app/main'
require 'timeout'


class AuctionSniperDriver

  def initialize(timeout_seconds)
    @timeout_seconds = timeout_seconds
    @top_level_frame = MainWindow::MAIN_WINDOW_NAME
  end

  def has_sniper_status?(status_text)
    has_eventually?(MainWindow::SNIPER_STATUS_NAME, :text, status_text)
  end

  def stop
  end

  private

  def has_eventually?(key, accessor, expected)
    Timeout::timeout(@timeout_seconds) do 
      loop do 
        break if JFrame::Widget_map.has_key?(key)
#        TestLogger.debug "Driver: No #{key}"
        sleep 0.1
      end

      loop do 
        actual = JFrame::Widget_map[key].send(accessor)
        break if actual == expected
#        TestLogger.debug "Driver: #{key} not set to #{expected}. Still #{actual}."
        sleep 0.1
      end
      true
    end
  rescue Timeout::Error
    false
  end
end
