module RailsSettings
  module Scopes
    def with_settings
      result = joins("INNER JOIN obj_settings ON #{settings_join_condition}")

      if ActiveRecord::VERSION::MAJOR < 5
        result.uniq
      else
        result.distinct
      end
    end

    def with_settings_for(var)
      raise ArgumentError.new('Symbol expected!') unless var.is_a?(Symbol)
      joins("INNER JOIN obj_settings ON #{settings_join_condition} AND obj_settings.var = '#{var}'")
    end

    def without_settings
      joins("LEFT JOIN obj_settings ON #{settings_join_condition}").
      where('obj_settings.id IS NULL')
    end

    def without_settings_for(var)
      raise ArgumentError.new('Symbol expected!') unless var.is_a?(Symbol)
      joins("LEFT JOIN obj_settings ON  #{settings_join_condition} AND obj_settings.var = '#{var}'").
      where('obj_settings.id IS NULL')
    end

    def settings_join_condition
      "obj_settings.target_id   = #{table_name}.#{primary_key} AND
       obj_settings.target_type = '#{base_class.name}'"
    end
  end
end
