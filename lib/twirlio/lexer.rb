class Lexer

  def tokenize(code)
    code.chomp!
    tokens = []


    i = 0
    while i < code.size
      chunk = code[i..-1]


      if parens = chunk[/\A(\(|\))/,1]
        tokens << [:PAREN, parens]
        i += parens.size
      elsif identifier = chunk[/\A([a-z]+)/, 1]
        tokens << [:IDEN, identifier]
        i+= identifier.size
      elsif string = chunk[/\A".+"/]
        tokens << [:STRING, string.gsub("\"","")]
        i += string.size
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



