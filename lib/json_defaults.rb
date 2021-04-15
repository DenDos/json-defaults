require 'json_defaults/version'

module JsonDefaults
  def json_defaults(field: nil, options: {}, active_record: false)
    options = options.stringify_keys
    define_json_methods(field, options)
    set_default_options(field, options) if defined?(ActiveRecord::Base) && ancestors.include?(ActiveRecord::Base)
  end

  private

  def define_json_methods(base_field, options)
    options.each do |field, defaults|
      define_getter(base_field, field, defaults)
      define_setter(base_field, field, defaults)
    end
  end

  def define_getter(base_field, field, defaults)
    return if attribute_names.include?(field)

    define_method field do
      val = send base_field
      if val && val.is_a?(Hash) && val.has_key?(field)
        val[field]
      elsif defaults.is_a?(Hash) && defaults.has_key?(:value)
        return defaults[:value]
      else
        return defaults.is_a?(Hash) ? defaults.stringify_keys : defaults
      end
    end
  end

  def get_defult_data(_get_defult_data)
    if defaults.is_a?(Hash) && defaults.has_key?(:value)
      defaults[:value]
    else
      defaults
    end
  end

  def define_setter(base_field, field, defaults)
    return if attribute_names.include?(field)

    define_method "#{field}=" do |val|
      object_value = send base_field
      object_value = {} unless val && val.is_a?(Hash)

      val = val.to_i if defaults.is_a?(Hash) && defaults.has_key?(:integer) && defaults[:integer]

      if defaults.is_a?(Hash) && defaults.has_key?(:boolean) && defaults[:boolean]
        val = val.is_a?(TrueClass) || val.respond_to?(:to_i) && val.to_i == 1
      end

      object_value[field] = val

      send("#{base_field}=", {
        **send(base_field.to_s).symbolize_keys,
        **object_value.symbolize_keys
           })
    end
  end

  def set_default_options(field, options)
    after_initialize do |model|
      if model.respond_to?(field)
        if model.send(field).blank?
          model.send("#{field}=", options.each do |key, value|
            options[key] = if value.is_a?(Hash) && value.has_key?(:value)
                             value[:value]
                           else
                             value
                           end
          end)
        else
          options.each do |key, value|
            have_key = model.send(field).key?(key.to_s)

            default_value = value.is_a?(Hash) && value.has_key?(:value) ? value[:value] : value
            default_value = default_value.stringify_keys if default_value && default_value.is_a?(Hash)

            model_value = model.send(field).try(:[], key.to_s).try(:stringify_keys)

            if !have_key
              model.send(field)[key] = default_value
            elsif have_key && model_value.is_a?(Hash)
              model.send(field)[key] = default_value.merge(model_value)
            end
          end
        end
      end
    end
  end
end
