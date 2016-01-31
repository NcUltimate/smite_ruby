module Smite
  class RecommendedItems < Smite::Object
    attr_reader :god_name, :role
    def initialize(god_name, data, role)
      @god_name = god_name
      @role     = role.downcase
      new_data  = {}

      data.each do |rec|
        next unless rec['Role'].downcase == @role

        new_data[rec['Category']] ||= []
        new_data[rec['Category']] << Smite::Game.device(rec['item_id'])
      end
      super(new_data)
    end

    def inspect
      "#<Smite::RecommendedItems '#{god_name}' Role: '#{role}'>"
    end
  end
end