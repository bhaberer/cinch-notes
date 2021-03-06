# -*- coding: utf-8 -*-
require 'cinch'
require 'cinch/storage'

module Cinch
  module Plugins
    # Cinch Plugin to send notes
    class Notes
      include Cinch::Plugin

      listen_to :channel, method: :send_notes
      set prefix: ''
      match(/\Atell (\w+) (.+)/, react_on: :private, method: :make_note)

      def initialize(*args)
        super
        @storage = Cinch::Storage.new(config[:filename] || 'yaml/notes.yml')
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
        return unless @storage.data.key?(nick)
        @storage.data[nick].each do |note|
          next if note.sent
          m.user.send("#{note.from} asked me to tell you '#{note.message}'")
          note.mark_sent
        end
        @storage.synced_save(@bot)
      end
    end
  end
end
