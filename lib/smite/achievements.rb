module Smite
  class Achievements < Smite::Object
    def initialize(data)
      if data.respond_to?(:to_ary)
        data = data.to_a[0]
      end
      super(data)
    end

    def inspect
      "#<Smite::Achievements '#{name}'>"
    end
  end
end