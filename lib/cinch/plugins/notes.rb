# -*- coding: utf-8 -*-
require 'cinch'

module Cinch::Plugins
  class Notes
    class Note
      attr_accessor :from, :to, :message, :time, :sent

      def initialize(from, to, message)
        @from = from
        @to = to
        @message = message
        @sent = false
        @time = Time.now
      end

      def to_yaml
        { from: from, to: to, message: message, time: time, sent: sent }
      end

      def send
        User(@to).send("#{@from} asked me to tell you '#{@message}'")
        @sent = true
      end
    end

    include Cinch::Plugin

    set prefix: /\Atell/, react_on: :private

    match /(\w+) (.+)/

    def initialize(*args)
      @storage = CinchStorage.new(config[:filename] || 'yaml/notes.yml')
      @storage.data ||= {}
    end

    def execute(m, user, message)
      note = Note.new(m.user.nick, user, message)
      @storage.data << note
      @storage.synced_save(@bot)
      m.reply 'ok, I will let them know!'
    end
  end
end
