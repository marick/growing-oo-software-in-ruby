require 'pp'
require 'spec/expectations'

After do
  @auction.stop
  @application.stop
end
