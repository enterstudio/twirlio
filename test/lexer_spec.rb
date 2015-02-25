require 'minitest/autorun'
require 'twirlio/lexer.rb'

describe Lexer do

  before :all do
    @lexer = Lexer.new
  end


  it "should lex left parens" do
    tokens = @lexer.tokenize "("
    tokens.must_equal [[:PAREN, "("]]
  end

  it "should lex right parens" do
    tokens = @lexer.tokenize ")"
    tokens.must_equal [[:PAREN, ")"]]
  end

  it "should lex parens group" do
    tokens = @lexer.tokenize "()"
    tokens.must_equal [[:PAREN, "(" ], [:PAREN, ")"]]
  end

  it "should lex parens with identifier" do
    tokens = @lexer.tokenize "foo("
    tokens.must_equal [
      [:IDEN, "foo"],
      [:PAREN, "("]
    ]
  end

  it "should lex a full parens struct" do
    tokens = @lexer.tokenize "(welcome foo )"
    tokens.must_equal [
      [:PAREN,"("],
      [:IDEN, "welcome"],
      [:IDEN, "foo"],
      [:PAREN,")"]
    ]
  end

  it "should match simple strings" do
    tokens = @lexer.tokenize "\"foo bar baz\""
    tokens.must_equal [[:STRING, "foo bar baz"]]
  end

  it "should lex a full example" do
    tokens = @lexer.tokenize "(welcome foo )\n(vab \"some string\")"
    tokens.must_equal [
      [:PAREN,"("],
      [:IDEN, "welcome"],
      [:IDEN, "foo"],
      [:PAREN,")"],
      [:PAREN,"("],
      [:IDEN, "vab"],
      [:STRING, "some string"],
      [:PAREN,")"],
    ]
  end

  it "should lex a welcome instruction" do

    code = "(welcome \"welcome to foo\")"
    tokens = @lexer.tokenize code
    tokens.must_equal [
      [:PAREN,"("],
      [:IDEN, "welcome"],
      [:STRING, "welcome to foo"],
      [:PAREN,")"],
    ]
  end

  it "should lex the empty program" do
    @lexer.tokenize("").must_equal []
  end


end
