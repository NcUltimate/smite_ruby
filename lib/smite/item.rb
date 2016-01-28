module Smite
  class Item < Smite::Object
    def inspect
      "#<Smite::Item '#{device_name}'>"
    end
  end
end