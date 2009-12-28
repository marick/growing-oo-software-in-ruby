require 'pp'
require 'spec/expectations'
require 'logger'
require 'app/main'
require 'external/blocking-queue'

TestLogger = Logger.new($stdout)
TestLogger.level = Logger::WARN
Main::Log.level = Logger::WARN
BlockingQueue::Log.level = Logger::WARN
SwingUtilities::Log.level = Logger::INFO

After do
  @auction.stop
  @driver.stop
  @application.stop
end

# If you run into a situation where a next step starts before
# everything in the previous one is finished, you can use this at the
# end of the previous one. 
def wait_for_quiet
  while ThreadGroup::Default.list.count > 1
    Thread.pass
  end
end
