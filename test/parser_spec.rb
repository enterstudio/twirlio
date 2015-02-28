require 'minitest/autorun'
require 'twirlio/parser.tab.rb'

describe Parser do

  before :each do
    @parser = Parser.new
  end

  it 'should parse a simple welcome' do
    code = "(send 'welcome to foo')"

    nodes = @parser.parse code
    nodes.nodes.must_equal [
      SendNode.new("welcome to foo")
    ]
  end

  it 'should parse an instruction set' do
    code = """
      (send 'Hi, welcome to the survey, please enter your name')
      (read name)
      (send 'Hi {{name}}, please enter M for male or F for female')
      (read gender)
      (send 'Hi {{name}}' )
    """

    nodes = @parser.parse(code).nodes
    nodes.must_equal [
      SendNode.new('Hi, welcome to the survey, please enter your name'),
      ReadNode.new('name'),
      SendNode.new('Hi {{name}}, please enter M for male or F for female'),
      ReadNode.new('gender'),
      SendNode.new('Hi {{name}}')
    ]
  end

  it 'should parse conditionals' do
    code = """
      (if (= foo 'bar')
        (send 'foo')
        (send 'bar'))
    """
    nodes = @parser.parse(code).nodes
    nodes.must_equal [
      ComparatorNode.new(
        ConditionNode.new('=','foo','bar'),
        [SendNode.new('foo')],
        [SendNode.new('bar')]
      )
    ]
  end

  it 'should parse multi-line conditionals' do
    # when
    code = """
      (if (= foo 'bar')
          ((send '1')
           (send '2')
           (send '2')
           (send '2')
           (send '3'))
          (send '2'))
    """
    nodes = @parser.parse(code).nodes

    # then
    nodes.must_equal [
      ComparatorNode.new(
        ConditionNode.new("=","foo","bar"),
        [SendNode.new('1'),
         SendNode.new('2'),
         SendNode.new('2'),
         SendNode.new('2'),
         SendNode.new('3')],
        [SendNode.new('2')]
      )
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
