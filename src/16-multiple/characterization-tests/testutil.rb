require 'mock-talk'
require 'logger'

TestLogger = Logger.new($stdout)
TestLogger.level = Logger::WARN
