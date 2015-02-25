class ProgramNode < Struct.new :nodes

end

class WelcomeNode < Struct.new :template

end

class StepNode < Struct.new :name, :template

end

class Nodes < Struct.new :nodes; end
