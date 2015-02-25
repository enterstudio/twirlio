# Grammar for the Parser generator

class Parser

  token PAREN
  token IDEN
  token STRING

rule

  program           : /* nothing */ { result = Nodes.new([]) }
                    | PAREN PAREN   { result = Nodes.new([]) }
                    | expressions   { result = Nodes.new val[0] }
                    ;

  expressions       : expression { result = val }
                    | expressions expression { result = val[0] << val[1] }
                    ;

  expression        : PAREN IDEN IDEN STRING PAREN { result = StepNode.new val[2], val[3] }
                    | PAREN IDEN STRING PAREN { result = WelcomeNode.new val[2] }
                    ;

---- header

  require "twirlio/nodes.rb"
  require "twirlio/lexer.rb"

---- inner

  def parse(code, show_tokens=false)
    @tokens = Lexer.new.tokenize(code) # Tokenize the code using our lexer
    puts @tokens.inspect if show_tokens
    do_parse # Kickoff the parsing process
  end

  def next_token
    @tokens = [] unless @tokens
    @tokens.shift
  end
