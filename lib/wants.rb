module Wants

  class <<self

    def new(env, mime_types)
      MatchResult.new(env, mime_types)
    end

    def mime_lookup_table
      @mime_lookup_table ||= begin
        require 'rack/mime'
        Rack::Mime::MIME_TYPES
      rescue LoadError
        {}
      end
    end

    attr_writer :mime_lookup_table
  end

end

require 'wants/match_result'
