#
# Supported tokens
#
# Keywords
#
# [:SEND, 'send']
# [:READ, 'read']
# [:EXIT, 'exit']
# [:IF, 'if']
#
# Special characters
#
# ['(','(']
# [')',')']
#
# Comparators
#
# [:COMPARATOR, '=']
# [:COMPARATOR, '<']
# [:COMPARATOR, '>']
#
# Identifiers
#
# [:IDEN, any_lower_case_words]
#
# Strings
#
# [:STRING, string] matches anything surrounded by " or '. Currently does not allow scaping
#
# Skips
# This lexer will skip any line that starts with the '#' character (comments), whitespace
# are skipped and line breaks are skipped.
#
#
class Lexer

  # @param {string} code a twisp program
  # @return a list a tokens where every token is an array with two values, the
  #         first one is the token identifier and the second one is the token's value.
  #
  def tokenize(code)
    code.chomp!
    tokens = []


    i = 0
    while i < code.size
      chunk = code[i..-1]

      # match comments
      if comment = chunk[/\A(#.*$)/,1]
        i += comment.size

      # match parenthesis
      elsif parens = chunk[/\A(\(|\))/,1]
        tokens << [parens, parens]
        i += parens.size

      # commands (send, read, exit, if)
      elsif command = chunk[/\A(send|read|exit|if)/,1]
        tokens << [command.upcase.to_sym, command]
        i += command.size

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



