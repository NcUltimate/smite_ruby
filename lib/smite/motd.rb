module Smite
  class MOTD < Smite::Object
    def initialize(data)
      super(data)
      @data['description'] = @data['description'].scan(/<li>([^<>]+)/).join("\n")
      @data['team1_gods']  = @data.delete('team1_gods_csv').split(/,\s/)
      @data['team2_gods']  = @data.delete('team2_gods_csv').split(/,\s/)
    end

    def date
      parse = Date.strptime(start_date_time, '%m/%d/%Y %H:%M:%S')
      parse.strftime('%m/%d')
    end

    def inspect
      "#<Smite::MOTD #{date} #{title}'>"
    end
  end
end