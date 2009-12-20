module SwingUtilities
  def self.invoke_and_wait(&block)
    thread = Thread.new do
      block.call
    end
    thread.join
  end
  
  def self.invoke_later(&block)
    Thread.new do
      Thread.pass   # This is the "later" part.
      block.call
    end
  end
end

class JFrame
  Widget_map = {}

  def name=(name)
    Widget_map[name] = self
  end

  def add(widget)
  end

  def close
    Widget_map.clear
    @on_window_closed_callback.call
  end

  def on_window_closed(&block)
    @on_window_closed_callback = block
  end

end

class JLabel < JFrame
  attr_accessor :text

  def initialize(text)
    @text = text
  end
end
