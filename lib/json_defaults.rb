require "json_defaults/version"
require "json_defaults/active_record" if defined?(Rails)

module JsonDefaults

  def json_defaults(field: nil, options: {}, active_record: false)
    define_json_methods(field, options)
    set_default_options(field, options) if active_record
  end
  
  private 

  # def set_default_options field, options
  #   after_initialize do |model|
  #     if model.class.columns_hash[field].type == :json
  #       if model.send(field).blank?
  #         model.send("#{field}=", options.each {|key, value| options[key] = value.is_a?(Hash) && value.has_key?(:value) ? value[:value] : value})
  #       else
  #         options.each do |key, value|
  #           have_key = model.send(field).key?(key.to_s)
  #           if !have_key 
  #             default_value = value.is_a?(Hash) && value.has_key?(:value) ? value[:value] : value
  #             model.send(field)[key] = default_value
  #           else
  #             model_value = model.send(field)[key.to_s]
  #             if model_value.is_a?(Hash) && !((value.keys - model_value.symbolize_keys.keys).count == 0)
  #               model.send(field)[key.to_s] = {
  #                 **value.symbolize_keys,
  #                 **model_value.symbolize_keys
  #               }
  #             end
  #           end
  #         end   
  #       end
  #       model.save if !model.changes.blank?
  #     end
  #   end
  # end

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
          return defaults[:value]
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
