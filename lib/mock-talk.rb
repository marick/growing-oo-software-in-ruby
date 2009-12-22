require 'test/unit'
require 'flexmock'
require 'flexmock/test_unit'
require 'shoulda'
require 'assert2'

# This file contains methods I find useful when using mocks.

# These methods are used to change the flow of control so that the
# test can state what is to happen before stating what the mock should
# receive.
class Test::Unit::TestCase

  attr_accessor :meaning_at_this_moment

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

end


class FlexMock::Expectation
  # For now, just token is recorded for the state of the test after some 
  # particular message is received.
  
  alias old_verify_call verify_call

  def verify_call(*args)
    @when_expectation_fulfilled.call if @when_expectation_fulfilled
    old_verify_call(*args)
  end

  def which_means(meaning)
    the_whole_test = mock.flexmock_container
    @when_expectation_fulfilled = lambda {
      the_whole_test.meaning_at_this_moment = meaning
    }
    self
  end

  def when(meaning)
    the_whole_test = mock.flexmock_container
    @when_expectation_fulfilled = lambda {
      FlexMock.check("Everything up to this point in the test was supposed to mean " + 
                     "'#{meaning}', but it meant " + 
                   "'#{the_whole_test.meaning_at_this_moment}'.") { 
        meaning == the_whole_test.meaning_at_this_moment
      }
    }
  end
end
    
