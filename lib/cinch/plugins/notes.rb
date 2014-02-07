# -*- coding: utf-8 -*-
require 'cinch'
require 'cinch-storage'

module Cinch::Plugins
  class Notes
    include Cinch::Plugin

    listen_to :channel,         method: :send_notes

    set prefix: ''

    match /\Atell (\w+) (.+)/,  react_on: :private,
                                method: :make_note

    def initialize(*args)
      super
      @storage = CinchStorage.new(config[:filename] || 'yaml/notes.yml')
      @storage.data ||= {}
    end

    def make_note(m, user, message)
      note = Note.new(m.user.nick, user, message)
      @storage.data[user.downcase] ||= []
      @storage.data[user.downcase] << note
      @storage.synced_save(@bot)
      m.reply 'ok, I will let them know!'
    end

    def send_notes(m)
      nick = m.user.nick.downcase
      if @storage.data.key?(nick)
        @storage.data[nick].each do |note|
          unless note.sent
            m.user.send("#{note.from} asked me to tell you '#{note.message}'")
            note.mark_sent
          end
        end
      end
    end

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

      def mark_sent
        @sent = true
      end
    end
  end
end
