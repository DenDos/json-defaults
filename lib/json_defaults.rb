require "json_defaults/version"
module JsonDefaults
  
  def json_defaults(base_field, options={})
    define_json_methods(base_field, options)
  end

  private 

  def define_json_methods(base_field, options)
    options.each do |field, defaults|
      define_getter(base_field, field, defaults)
      define_setter(base_field, field, defaults)
    end
  end

  def define_getter base_field, field, defaults
    define_method field do
      val = send base_field
      if val && val.is_a?(Hash) && val.has_key?(field)
        val[field]
      else
        if defaults.is_a?(Hash) && defaults.has_key?(:value)
          defaults[:value]
        else
          return defaults
        end
      end
    end
  end

  def define_setter base_field, field, defaults
    define_method "#{field}=" do |val|
      object_value = send base_field
      unless val && val.is_a?(Hash)
        object_value = {}
      end
      
      if defaults.is_a?(Hash) && defaults.has_key?(:integer) && defaults[:integer]
        val = val.to_i
      end

      if defaults.is_a?(Hash) && defaults.has_key?(:boolean) && defaults[:boolean]
        val = val.is_a?(TrueClass) || val.respond_to?(:to_i) && val.to_i == 1
      end

      object_value[field] = val
      
      send("#{base_field}=", {
        **send("#{base_field}").symbolize_keys,
        **object_value.symbolize_keys
      })
    end
  end
end
