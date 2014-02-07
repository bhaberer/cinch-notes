# -*- coding: utf-8 -*-
module Cinch::Plugins
  class Notes
    # Object to store note information
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
