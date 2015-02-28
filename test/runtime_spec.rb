require 'minitest/autorun'
require 'twirlio/runtime'

class MockSender

  attr_reader :messages

  def initialize()
    @messages = []
  end

  def say(message)
    @messages << message
  end
end

class MockReader

  attr_accessor :messages

  def initialize()
    @messages = []
  end

  def read
    @messages.shift
  end
end

describe Runtime do

  before :each do
    @sender = MockSender.new
    @reader = MockReader.new
    @runtime = Runtime.new @sender, @reader
  end

  describe "read" do

    it 'should be able to store variables' do

      # when
      @reader.messages = ["foo"]

      # then
      code = "(read variable)"
      ctx = @runtime.execute(code)
      ctx['variable'].must_equal "foo"
      ctx.size.must_equal 1
    end

    it 'should be able to rewrite variables' do

      # when
      @reader.messages = ["1","2"]
      code = "(read var)(read var)"
      ctx = @runtime.execute(code)

      # then
      ctx.must_equal({ 'var'=> '2' })
    end

  end

  describe "send" do

    it 'should output messages with the send command' do

      # when
      msg = "what is up"
      code = "(send '#{msg}')"

      # then
      ctx = @runtime.execute code
      ctx.size.must_equal 0
      @sender.messages.must_equal [msg]
    end

  end

  describe "exit" do

    it 'should exit execution after the exit command is placed' do

      # when
      code = """
        (send 'foo')
        (exit)
        (send 'laksjdhf')
        (send 'asdfasdf')
        (read bar)
        (read baz)
      """
      ctx = @runtime.execute code

      # then
      ctx.size.must_equal 0
      @sender.messages.must_equal ['foo']
    end

    it 'should not output a msg when no param is passed to it' do

      # when
      @runtime.execute "(exit)"

      # then
      @sender.messages.must_equal []
    end

    it 'should output a msg when a param is passed to exit' do

      # when
      @runtime.execute "(exit 'foobar')"

      # then
      @sender.messages.must_equal ['foobar']
    end

  end

  describe "if" do
    it "should branch the execution flow" do

      # when
      code = """
        (read var)
        (if (= var 'foo')
            (send '1')
            (send '2'))
      """
      @reader.messages = ["foo"]
      @runtime.execute code

      # then
      @sender.messages.must_equal ['1']
    end

    it 'should not break the execution flow' do

      # when
      code = """
        (read var)
        (if (= var 'foo')
            (send '1')
            (send '2'))
        (send 'this line should execute')"""
      @reader.messages = ["foo"]
      @runtime.execute code

      # then
      @sender.messages.must_equal ['1','this line should execute']

    end

    it 'should execute the second block if the condition is not met' do

      # when
      code = """
        (read var)
        (if (= var 'foo')
            (send '1')
            (send '2'))
        (send 'this line should execute')"""
      @reader.messages = ["fu"]
      @runtime.execute code

      # then
      @sender.messages.must_equal ['2','this line should execute']

    end

    it 'should support multi-line statements inside' do

      # when
      code = """
        (read var)
        (if (= var 'foo')
            ((send '1')
             (send '2')
             (send 'last'))
            ((send '3')
             (send '4')))
        (send 'end')
      """
      @reader.messages = ["foo"]
      @runtime.execute code

      # then
      @sender.messages.must_equal ['1','2','last','end']

    end
  end

  it 'should run the empty program' do
    ctx = @runtime.execute "()"
    ctx.must_equal Hash.new
  end

end
