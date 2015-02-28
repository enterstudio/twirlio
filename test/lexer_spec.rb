require 'minitest/autorun'
require 'twirlio/lexer.rb'

describe Lexer do

  before :all do
    @lexer = Lexer.new
  end


  it "should lex left parens" do
    tokens = @lexer.tokenize "("
    tokens.must_equal [["(", "("]]
  end

  it "should lex right parens" do
    tokens = @lexer.tokenize ")"
    tokens.must_equal [[")", ")"]]
  end

  it "should lex parens group" do
    tokens = @lexer.tokenize "()"
    tokens.must_equal [["(", "(" ], [")", ")"]]
  end

  it "should lex parens with identifier" do
    tokens = @lexer.tokenize "foo("
    tokens.must_equal [
      [:IDEN, "foo"],
      ["(", "("]
    ]
  end

  it 'should accept underscored identifiers' do
    tokens = @lexer.tokenize "foo_bar_baz zoo_ba_boo("
    tokens.must_equal [
      [:IDEN, "foo_bar_baz"],
      [:IDEN, "zoo_ba_boo"],
      ["(", "("]
    ]
  end

  it "should lex the empty program" do
    @lexer.tokenize("").must_equal []
  end

  it 'should lex the "if" program' do
    code = """
      (if (= foo 'bar')
    """
    tokens = @lexer.tokenize(code)
    tokens.must_equal [
      ['(','('],
      [:IF,'if'],
      ['(','('],
      [:COMPARATOR, '='],
      [:IDEN, 'foo'],
      [:STRING, 'bar'],
      [')',')']
    ]
  end

  it 'should lex a full prog' do
    code = """
      (send 'Hi, welcome to the survey, please enter your name')
      (read name)
      (send 'Hi {{name}}, please enter M for male or F for female')
      (read gender)
      (send 'Hi {{name}}, it appears your gender is {{gender}}')
      (if (= name 'foo')
        (send 'hi foo')
        (send 'your name is not foo'))
    """
    tokens = @lexer.tokenize(code)
    must_match_tokens(tokens,
                      '(', :SEND, :STRING, ')',
                      '(', :READ, :IDEN, ')',
                      '(', :SEND, :STRING, ')',
                      '(', :READ, :IDEN, ')',
                      '(', :SEND, :STRING, ')',
                      '(', :IF, '(', :COMPARATOR, :IDEN, :STRING, ')',
                      '(', :SEND, :STRING, ')',
                      '(', :SEND, :STRING, ')',')')

  end


  def must_match_tokens(tokens, *args)
    tokens.size.must_equal args.size
    tokens.each_with_index do |token, index|
      token[0].must_equal(args[index])
    end
  end


end
