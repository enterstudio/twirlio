require 'twilio-ruby'

class Sender

  def say(message)
  end
end

class StdOutSender < Sender

  def say(message)
    puts "Sending fake sms..."
    puts "\t message"
  end
end

class TwilioSender < Sender

  def initialize(account_sid, auth_token, from, to)
    @client = Twilio::REST::Client.new account_sid, auth_token
    @from, @to = from, to
  end

  def say(message)
    @client.account.messages.create(
      :from => from,
      :to => to,
      :body => message
    )
  end
end
