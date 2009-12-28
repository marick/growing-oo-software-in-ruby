def ValueObjectClass(*attributes)
  setters = attributes.collect { | attr | 
    %Q{
      def #{attr}=(value)
        raise "Does your mother know you try to change values in value objects?" 
      end
    }
  }.join
  val = %Q{
    Class.new(Struct.new(*#{attributes.inspect})) do
      def self.new(hash={})
        values = #{attributes.inspect}.collect do | attr | 
          raise "No argument given for \#{attr.inspect}." unless hash.has_key?(attr)
          hash[attr]
        end
        super(*values)
      end
      #{setters}
    end
  }
  # puts val
  eval(val)
end
