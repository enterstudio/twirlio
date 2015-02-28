# When executed this node sends a new message
class SendNode < Struct.new :template; end

# when executed this nodes waits to read the contents of a message
class ReadNode < Struct.new :attr_name; end

# when executed this node exits the program and returns the current context
class ExitNode < Struct.new :template; end

# when executed this node branches out the execution of the program
# this node is functionally equivalent to an if
class ComparatorNode < Struct.new :condition, :when_true, :when_false

  def verify_condition(ctx)
    comparator = condition.comparator

    if comparator == '='
      return ctx[condition.attr_name] == condition.value
    elsif comparator == '<'
      return ctx[condition.attr_name].to_f < condition.value.to_f
    elsif comparator == '>'
      return ctx[condition.attr_name].to_f > condition.value.to_f
    else
      raise "Unkown comparator #{comparator}"
    end
  end

end

# this node represents a condition e.g. (= a b)
class ConditionNode < Struct.new :comparator, :attr_name, :value; end

# a node that contains a list of instructions
class ListNode < Struct.new :nodes; end

# the whole program
class Nodes < Struct.new :nodes; end
