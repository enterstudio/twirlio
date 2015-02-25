require 'minitest/autorun'
require 'twirlio/parser.tab.rb'

describe Parser do

  before :each do
    @parser = Parser.new
  end

  it 'should parse a simple welcome' do
    code = """
    (welcome \"welcome to foo\")
    """
    nodes = @parser.parse code
    nodes.nodes.must_equal [
      WelcomeNode.new("welcome to foo")
    ]
  end

  it 'should parse an instruction set' do
    code = """
      (welcome 'foo bar')
      (step name 'response')
      (step age 'response 2')
      (step lastname 'hi {name}')
      """
    nodes = @parser.parse(code).nodes
    nodes.must_equal [
      WelcomeNode.new('foo bar'),
      StepNode.new('name', 'response'),
      StepNode.new('age','response 2'),
      StepNode.new('lastname','hi {name}')
    ]
  end

  it 'should parse the empty program' do
    code = ""
    nodes = @parser.parse code
    nodes.nodes.must_equal []
  end

  it 'should parse the empty program ()' do
    code = "()"
    nodes = @parser.parse code
    nodes.nodes.must_equal []
  end


end
