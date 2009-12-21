def me(text)
  self.class.name + " " + text
end

def NullImplementation
  def initialize(*args)
  end

  def method_missing(message, *args)
  end
end
