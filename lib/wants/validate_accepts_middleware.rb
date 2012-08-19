require 'wants/match_result'

module Wants
  class ValidateAcceptsMiddleware

    DEFAULT_ON_NOT_ACCEPTABLE = lambda do |env|
      [
        406,
        {
          'Content-Type' => 'text/plain',
          'Content-Length' => '14'
        },
        [ 'Not Acceptable' ]
      ]
    end

    def initialize(app, options)
      @app = app

      @mime_types = options[:mime_types]
      raise ArgumentError.new("#{self.class} requires option :mime_types") unless @mime_types

      @on_not_acceptable = options[:on_not_acceptable] || DEFAULT_ON_NOT_ACCEPTABLE
    end

    def call(env)
      if MatchResult.new(env, @mime_types).present?
        @app.call(env)
      else
        @on_not_acceptable.call(env)
      end
    end

  end
end
