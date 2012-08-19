module Wants

  def self.new(env, mime_types)
    MatchResult.new(env, mime_types)
  end

end

require 'wants/match_result'
