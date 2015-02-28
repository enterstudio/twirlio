class Lexer

  def tokenize(code)
    code.chomp!
    tokens = []


    i = 0
    while i < code.size
      chunk = code[i..-1]


      # match parenthesis
      if parens = chunk[/\A(\(|\))/,1]
        tokens << [parens, parens]
        i += parens.size

      # commands (send, read, exit)
      elsif command = chunk[/\A(send|read|exit)/,1]
        tokens << [command.upcase.to_sym, command]
        i += command.size

      # 'if' keyword
      elsif ifkw = chunk[/\A(if)/,1]
        tokens << [ifkw.upcase.to_sym, ifkw]
        i += ifkw.size

      # comparators
      elsif comparator = chunk[/\A(=|<|>)/,1]
        tokens << [:COMPARATOR, comparator]
        i += comparator.size

      # identifiers
      elsif identifier = chunk[/\A([a-z]+([_a-z]+)?)/, 1]
        tokens << [:IDEN, identifier]
        i+= identifier.size

      # strings "
      elsif string = chunk[/\A".+"/]
        tokens << [:STRING, string.gsub("\"","")]
        i += string.size

      # strings '
      elsif string = chunk[/\A'.+'/]
        tokens << [:STRING, string.gsub("\'","")]
        i += string.size

      # skip spaces
      elsif chunk.match(/\A /)
        i += 1

      # skip \n
      elsif new_line = chunk[/\A(\n)/, 1]
        i += new_line.size
      else
        raise "Could not match '#{chunk}'"
      end

    end

    return tokens
  end

end



