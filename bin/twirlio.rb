#!/usr/bin/ruby -Ilib

require 'twirlio/runtime.rb'

code_path = ARGV[0]

code = File.read(code_path)

class StdOutSender
  def say(message)
    STDOUT.puts message
  end
end

class StdInReader
  def read
    STDIN.gets
  end
end

@runtime = Runtime.new(StdOutSender.new, StdInReader.new)
@runtime.execute(code)




