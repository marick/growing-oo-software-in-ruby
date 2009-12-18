require 'pp'
require 'spec/expectations'
require 'logger'
require 'app/main'
require 'external/blocking-queue'

TestLogger = Logger.new($stdout)
TestLogger.level = Logger::WARN
Main::Log.level = Logger::WARN
BlockingQueue::Log.level = Logger::WARN

After do
  @auction.stop
  @driver.stop
  @application.stop
end

def wait_for_quiet
  while ThreadGroup::Default.list.count > 1
    Thread.pass
  end
end
