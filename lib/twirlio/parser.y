# Grammar for the Parser generator

class Parser

  token IDEN
  token STRING
  token SEND
  token READ
  token EXIT
  token IF
  token COMPARATOR

rule

  program           : /* nothing */ { result = Nodes.new([]) }
                    | '(' ')'   { result = Nodes.new([]) }
                    | expressions   { result = Nodes.new val[0] }
                    ;

  expressions       : expression { result = val }
                    | expressions expression { result = val[0] << val[1] }
                    ;

  expression        : '(' SEND STRING ')' { result = SendNode.new val[2] }
                    | '(' READ IDEN ')' { result = ReadNode.new val[2] }
                    | '(' IF condition block block ')' { result = ComparatorNode.new val[2], val[3] , val[4] }
                    | '(' EXIT ')' { result = ExitNode.new '' }
                    | '(' EXIT STRING ')' { result = ExitNode.new val[2] }
                    ;

  block             : '(' expressions ')' { result = val[1] }
                    | expression { result = [val[0]] }

  condition         : '(' COMPARATOR IDEN STRING ')' { result = ConditionNode.new val[1], val[2], val[3] }
  condition         : '(' COMPARATOR STRING IDEN ')' { result = ConditionNode.new val[1], val[3], val[2] }

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
