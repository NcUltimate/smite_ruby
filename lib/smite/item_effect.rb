module Smite
  class ItemEffect
    attr_accessor :attribute, :amount, :percentage
    attr_reader :device_name

    def initialize(item, data = {})
      @device_name = item
      return if data.empty?

      effect = data.delete('Description').tr(' ','')
      effect = ActiveSupport::Inflector.underscore(effect)

      @attribute = effect
      @attribute = 'magic_protection' if effect == 'magical_protection'
      @attribute = 'magical_power'    if effect == 'magic_power'

      value       = data.delete('Value')
      @percentage = value[/%/]

      value   = value.tr('+', '').to_i
      @amount = value
    end

    def percentage?
      !percentage.nil?
    end

    def to_h
      { attribute => { amount: amount, percentage: percentage? } }
    end

    def inspect
      "#<Smite::ItemEffect '#{device_name}' #{attribute} +#{amount}#{percentage}>"
    end
  end
end