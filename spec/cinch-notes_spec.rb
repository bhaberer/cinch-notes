require 'spec_helper'

describe Cinch::Plugins::Notes do
  include Cinch::Test

  before(:each) do
    @bot = make_bot(Cinch::Plugins::Notes, { filename: '/tmp/notes.yml' })
  end

  describe 'handling hangout links' do
    it 'should accept a message to give to someone later' do
      get_replies(make_message(@bot, 'tell foo bar'), :private).first.text.
        should == "ok, I will let them know!"
    end

    it 'should send the message when someone talks later' do
      get_replies(make_message(@bot, 'tell joe bar'), :private)
      get_replies(make_message(@bot, 'hi', { nick: 'joe', channel: '#foo' })).first.text.
        should == "test asked me to tell you 'bar'"
    end
  end
end
