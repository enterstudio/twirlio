require 'twirlio/parser.tab.rb'
require 'mustache'

class Runtime


  def initialize(sender, reader)
    @parser = Parser.new
    @sender, @reader = sender, reader
  end

  def execute(code, debug=false)
    nodes = @parser.parse(code, debug).nodes
    ctx = {}

    # initialize the 'nodes_to_execute' list
    nodes_to_execute = nodes

    # finish the execution of the program when
    # there are no more nodes in 'nodes_to_execute'
    while not nodes_to_execute.empty? do

      # take the first node
      curr_node = nodes_to_execute.shift

      if curr_node.is_a? ExitNode
        message = Mustache.render(curr_node.template, ctx)
        @sender.say message if message.size > 0
        return ctx

      # Execute a SendNode
      elsif curr_node.is_a? SendNode
        message = Mustache.render(curr_node.template, ctx)
        @sender.say message

      # Execute a ReadNode
      elsif curr_node.is_a? ReadNode
        value_read = @reader.read.chomp
        ctx[curr_node.attr_name] = value_read

      # Execute a ComparatorNode
      elsif curr_node.is_a? ComparatorNode
        valid = curr_node.verify_condition(ctx)
        if valid
          nodes_to_execute = curr_node.when_true + nodes_to_execute
        else
          nodes_to_execute = curr_node.when_false + nodes_to_execute
        end
      end

      # when in debug mode:
      if debug
        puts "Executing: #{curr_node}, press enter to continue"
        readline
      end

    end

    return ctx
  end

  def next_node(nodes, node)
    index = nodes.find_index(node)
    if index.nil?
      return nil
    else
      return nodes[index + 1]
    end
  end

end


