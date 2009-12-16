require 'xmpp4r-simple'
require 'monitor'


class MessageQueue
  def initialize(wait_time)
    @wait_time_in_seconds = wait_time
    @queue = []
    @queue.extend(MonitorMixin)
    @condition = @queue.new_cond
  end


  def has_entry?
    puts "#{Time.now}: entering has_entry?"
    @queue.synchronize do 
      while @queue.empty?
        unless @condition.wait(@wait_time_in_seconds)
          puts "#{Time.now}: timeout"
          return false
        end
      end
      puts "#{Time.now}: queue is not empty"
      true
    end
  end

  def add_to_end(thing)
    @queue.synchronize do 
      @queue < thing
      @condition.signal
    end
  end
end

class FakeAuctionServer

  attr_reader :item_id

  def initialize(item_id)
    @item_id = item_id
    @message_queue = MessageQueue.new(50)
  end

  def start_selling_item
    jid_string = "auction-#{@item_id}@#{XMPP_HOSTNAME}/#{XMPP_RESOURCE}"
    puts jid_string
    @connection = Jabber::Simple.new(jid_string, XMPP_PASSWORD)

    @connection.received_messages { | msg | 
      puts "received: #{msg}"
      @message_queue.add_to_end(msg) if msg.type == :chat
    }
  end

  def has_received_join_request_from_sniper?
    puts "Have I received a join request?"
    @message_queue.has_entry?
  end

  def stop
    @connection.disconnect
  end

  def log(message); puts "#{$0}: " + message; end

end

if $0 == __FILE__
  require 'constants'
  FakeAuctionServer.new(ONE_ITEM).start_selling_item
  puts Thread.list.inspect
  # hack
  Thread.list[1].join
end

