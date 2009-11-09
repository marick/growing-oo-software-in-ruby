require 'test/unit'
require 'flexmock/test_unit'
require 'shoulda'
require 'assert2'

# This file contains methods I find useful when using mocks.

# These methods are used to change the flow of control so that the
# test can state what is to happen before stating what the mock should
# receive.
class Test::Unit::TestCase
  def because(&block)
    @because = block
    self
  end
  alias_method :during, :because
  alias_method :whenever, :because

  def behold!
    yield
    @result = @because.call
  end

  # Shouldn't use this with partial mocks, since it doesn't
  # trap the underlying class's methods. You don't know that
  # *nothing* happens, only that default mocks weren't called.
  def behold_nothing_happens!
    behold! {}
  end


  # Easy mock setup

  # Use like this:
  # Timeslice.new(mocks(:use_source, :procedure_source, :hash_maker))
  #
  # ...
  #
  # @use_source.should_expect(...)
  #
  # 
  # See util/test-support.rb for how tested classes should arrange
  # for easy mocking.

  def mocks(*symbols)
    hash = {}
    symbols.each do | symbol | 
      name = symbol.to_s
      a_mock = flexmock(name)
      instance_variable_set("@#{name}", a_mock)
      hash[symbol] = a_mock
    end
    hash
  end

end
