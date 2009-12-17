require 'monitor'
require 'logger'

# Should use the SizedQueue from thread library.

class BlockingQueue

  Log = Logger.new($stdout)
  Log.level = Logger::WARN

  def initialize
    @wait_time_in_seconds = 5
    @queue = []
    @queue.extend(MonitorMixin)
    @condition = @queue.new_cond
  end


  def has_entry?
    Log.debug("#{Time.now}: entering blocking queue has_entry?")
    @queue.synchronize do 
      while @queue.empty?
        unless @condition.wait(@wait_time_in_seconds)
          Log.debug "#{Time.now}: timeout"
          return false
        end
      end
      Log.debug("#{Time.now}: queue is not empty")
      true
    end
  end

  def << (thing)
    @queue.synchronize do 
      @queue << thing
      @condition.signal
    end
  end
end
