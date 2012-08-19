module Wants
  class MatchResult

    def initialize(env, acceptable)
      @env, @acceptable = env, acceptable
    end

    def not_acceptable?
      true
    end

    def blank?
      not_acceptable?
    end

    def present?
      !blank?
    end

  end
end
