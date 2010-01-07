require 'monitor'
require 'logger'
require 'test/unit/assertions'

# Should use the SizedQueue from thread library.

class BlockingQueue
  include Test::Unit::Assertions

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
      wait_for_something
      true
    end
  end

  def enqueue (thing)
    Log.debug("Blocking queue adding #{thing.inspect}.")
    @queue.synchronize do 
      @queue << thing
      @condition.signal
    end
  end

  def dequeue
    Log.debug("Going to dequeue from what is currently #{@queue.inspect}.")
    @queue.synchronize do 
      wait_for_something
      @queue.shift
    end
  end

  private

  def wait_for_something
    while @queue.empty?
      unless @condition.wait(@wait_time_in_seconds)
        flunk("Timed out waiting for a message on the queue.")
      end
    end
  end
end
