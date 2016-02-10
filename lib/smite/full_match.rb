module Smite
  class FullMatch < Smite::Object
    attr_accessor :queue, :match

    def initialize(data)
      data = { 'competitors' => data.map { |k, v| Smite::Competitor.new(k) } }
      super
      @queue = competitors[0].queue
      @match = competitors[0].match
    end

    def teams
      { team1: team1, team2: team2 }
    end

    def parties
      competitors.group_by(&:party_id)
    end

    def players
      competitors
    end

    def size
      competitors.count
    end

    def ranked?
      queue =~ /Ranked/
    end

    def size_str
      "#{size/2} v #{size/2}"
    end

    def team1
      competitors[0...size/2]
    end

    def team2
      competitors[size/2..-1]
    end

    def winning_team
      return @winner unless @winner.nil?

      @winner = teams.find do |team, competitors|
        competitors.all? { |competitor| competitor.winner? }
      end
      @winner = @winner[0]
    end

    def inspect
      "#<Smite::FullMatch #{match} #{queue}>"
    end
  end
end