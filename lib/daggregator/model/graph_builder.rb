class Daggregator::Model::GraphBuilder
  attr_reader :identifier_proc, :keys, :flows_to, :flows_from

  def initialize(type = nil)
    unless type.nil?
      # Default to using the node type as the prefix
      @identifier_proc  = Proc.new {|instance| "#{type}_#{instance.id}" }
    else
      # If none specified for some reason, use the instance class name
      @identifier_proc  = Proc.new {|instance| "#{instance.class.name}_#{instance.id}" }
    end
    @keys             = {}
    @flows_to         = {}
    @flows_from       = {}
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
    key_name = key_name.to_s
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

  # flows[association name on model] = [node type on associated]
  #
  def flow_to(association_name, args={}, &block)
    association_name = association_name.to_s
    # RM NOTE: you should probably set up identifier for the target class 
    # if it isn't already

    @flows_to[association_name] ||= {'types' => []}
    @flows_to[association_name]['types'] << ( args[:as] || :default ).to_s
    @flows_to[association_name]['block'] = block_given? ? block : Proc.new { self }
  end

  def flow_from(association_name, args={}, &block)
    association_name = association_name.to_s
    # RM NOTE: you should probably set up identifier for the target class 
    # if it isn't already

    @flows_from[association_name] ||= {'types' => []}
    @flows_from[association_name]['types'] << ( args[:as] || :default ).to_s
    @flows_from[association_name]['block'] = block_given? ? block : Proc.new { self }
  end
end
