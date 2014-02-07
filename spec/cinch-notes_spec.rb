require 'spec_helper'

describe Cinch::Plugins::Hangouts do
  include Cinch::Test

  before(:each) do
    files = { hangout_filename: '/tmp/hangout.yml',
              subscription_filename: '/tmp/subscription.yml' }
    files.values.each do |file|
      File.delete(file) if File.exist?(file)
    end
    @bot = make_bot(Cinch::Plugins::Hangouts, files)
  end

  describe 'handling hangout links' do
    it 'should return an error if no one has linked a hangout' do
      get_replies(make_message(@bot, '!hangouts', { channel: '#foo' })).first.text.
        should == "No hangouts have been linked recently!"
    end

    it 'should not capture a malformed (invalid chars) Hangout link' do
      msg = make_message(@bot, Hangout.url('82b5cc7f76b7a%19c180416c2f509027!!d8856d', false),
                               { :channel => '#foo' })
      get_replies(msg).should be_empty
      msg = make_message(@bot, '!hangouts')
      get_replies(msg).first.text.
        should == "No hangouts have been linked recently!"
    end

    it 'should not capture a malformed (wrong length) Hangout link' do
      msg = make_message(@bot, Hangout.url('82b5cc', false),
                               { :channel => '#foo' })
      get_replies(msg).should be_empty
      msg = make_message(@bot, '!hangouts')
      get_replies(msg).first.text.
        should == "No hangouts have been linked recently!"
    end

    it 'should capture a legit Hangout link and store it in @storage' do
      msg = make_message(@bot, Hangout.url(random_hangout_id, false), { :channel => '#foo' })
      get_replies(msg).should be_empty
      sleep 1 # hack until 'time-lord' fix gets released
      msg = make_message(@bot, '!hangouts')
      reply = get_replies(msg).last.text
      reply.should include "test started a hangout at"
      reply.should match(/it was last linked \d seconds? ago/)
    end

    it 'should capture a legit Hangout link if it has trailing params' do
      msg = make_message(@bot, Hangout.url(random_hangout_id + '?hl=en', false),
                               { :channel => '#foo' })
      get_replies(msg)
      sleep 1 # hack until 'time-lord' fix gets released
      msg = make_message(@bot, '!hangouts')
      reply = get_replies(msg).last.text
      reply.should include "test started a hangout at"
      reply.should match(/it was last linked \d seconds? ago/)
    end

    it 'should capture a new short Hangout link and store it in @storage' do
      msg = make_message(@bot, Hangout.url('7acpjrpcmgl00u0b665mu25b1g', false), { :channel => '#foo' })
      get_replies(msg).should be_empty
      sleep 1 # hack until 'time-lord' fix gets released
      msg = make_message(@bot, '!hangouts')
      reply = get_replies(msg).last.text
      reply.should include "test started a hangout at"
      reply.should match(/it was last linked \d seconds? ago/)
    end
  end

  describe 'subscriptions' do
    it 'should allow users to subscribe' do
      msg = make_message(@bot, '!hangouts subscribe')
      get_replies(msg).first.text.
        should include("You are now subscribed")
    end

    it 'should allow users to subscribe' do
      msg = make_message(@bot, '!hangouts subscribe')
      get_replies(msg).first.text.
        should include("You are now subscribed")
    end

    it 'should inform users that they already subscribed' do
      get_replies(make_message(@bot, '!hangouts subscribe'))
      msg = make_message(@bot, '!hangouts subscribe')
      get_replies(msg).first.text.
        should include("You are already subscribed")
    end

    it 'should allow users to unsubscribe' do
      get_replies(make_message(@bot, '!hangouts subscribe'))
      msg = make_message(@bot, '!hangouts unsubscribe')
      get_replies(msg).first.text.
        should include("You are now unsubscribed")
    end

    it 'should inform users that they are not subscribed on an unsubscribe' do
      msg = make_message(@bot, '!hangouts unsubscribe')
      get_replies(msg).first.text.
        should include("You are not subscribed.")
    end

    #it 'should notify users when a new hangout is linked' do
    #  get_replies(make_message(@bot, '!hangouts subscribe'), { channel: '#foo', nick: 'joe' } )
    #  msgs = get_replies(make_message(@bot, Hangout.url(random_hangout_id, false), { channel: '#foo', nick: 'josh' }))
    #  msgs.first.should_not be_nil
    #end

    it 'should not notify users when an old hangout is relinked' do
      get_replies(make_message(@bot, '!hangouts subscribe'), { :channel => '#foo' } )
      get_replies(make_message(@bot, Hangout.url(random_hangout_id, false), { :channel => '#foo' }))
      msg = make_message(@bot, Hangout.url(random_hangout_id, false), { :channel => '#foo' })
      get_replies(msg).
        should be_empty
    end
  end

  def random_hangout_id(len = 40)
    chars = %w{ a b c d e f 0 1 2 3 4 5 6 7 8 9 }
    string = ''
    len.times { string << chars[rand(chars.length)] } 
    string
  end
end
