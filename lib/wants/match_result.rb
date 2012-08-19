require 'wants/mimeparse'

module Wants
  class MatchResult

    def initialize(env, acceptable)
      @accept = env['Accept'] || ''
      @acceptable = acceptable.map { |mime| parse_mime(mime) }
      @best_match = MIMEParse.best_match(@acceptable, @accept)
    end

    def not_acceptable?
      @best_match.nil?
    end

    def blank?
      not_acceptable?
    end

    def present?
      !blank?
    end

    def [](mime)
      @best_match == parse_mime(mime)
    end

    def any(&block)
      @response_value ||= block.call if present?
    end

    def not_acceptable(&block)
      @response_value ||= block.call if blank?
    end

    def method_missing(method, *args, &block)
      if mime = mime_abbreviation_from_method(method)
        if args.length > 0
          raise ArgumentError, "wrong number of arguments (#{args.length} for 0)"
        end
        if method =~ /\?$/
          self[mime]
        elsif self[mime]
          @response_value ||= block.call
        else
          @response_value
        end
      else
        super
      end
    end

    def respond_to?(method)
      return true if mime_abbreviation_from_method(method)
      super
    end

    private

    def parse_mime(mime)
      Wants.mime_lookup_table[".#{mime}"] || mime.to_s
    end

    def mime_abbreviation_from_method(method)
      md = /([^\?]+)\??$/.match(method)
      md && Wants.mime_lookup_table[".#{md[1]}"]
    end

  end
end
