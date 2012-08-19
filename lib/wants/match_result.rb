require 'wants/mimeparse'

module Wants
  class MatchResult

    def initialize(env, acceptable)
      @accept = env['Accept'] || ''
      @acceptable = parse_acceptable(acceptable)
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

    private

    def parse_acceptable(acceptable)
      lookup_table = Wants.mime_lookup_table
      acceptable.map { |mime| lookup_table[".#{mime}"] || mime.to_s }
    end

    def parse_mime(mime)
      lookup_table = Wants.mime_lookup_table
      lookup_table[".#{mime}"] || mime.to_s
    end

  end
end
