class Daggregator::Model::GraphBuilder
  attr_reader :identifier_proc, :keys, :flows

  def initialize
    @identifier_proc  = Proc.new {|instance| "#{instance.class.name}_#{instance.id}" }
    @keys             = {}
    @flows            = {}
  end

  def identifier(prefix = nil, &block)
    if not prefix and not block_given?
      raise ArgumentError "Why are you calling identifier with no arguments?"
    elsif prefix
      block = Proc.new {|instance| "#{prefix}_#{instance.id}" }
    end

    @identifier_proc = block
  end

  def key(key_name, args={}, &block)
    if not key_name
      raise ArgumentError, "You must tell me what key you want to push to"
    end

    if not block_given? and not args[:from]
      block = Proc.new { send(key_name) }
    elsif args[:from]
      block = Proc.new { send(args[:from]) }
    elsif not block_given?
      block = Proc.new { send(key_name) }
    end

    @keys[key_name] = block
  end

  def flow_to(association_name, args={})
    # RM NOTE: you should probably set up identifier for the target class 
    # if it isn't already

    @flows[association_name] ||= []
    @flows[association_name] << ( args[:as] || association_name )
  end
end
