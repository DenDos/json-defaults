module JsonDefaults
  module ActiveRecord
    private 
    
      def set_default_options field, options
        after_initialize do |model|
          if model.class.columns_hash[field].type == :json
            if model.send(field).blank?
              model.send("#{field}=", options.each {|key, value| options[key] = value.is_a?(Hash) && value.has_key?(:value) ? value[:value] : value})
            else
              options.each do |key, value|
                have_key = model.send(field).key?(key.to_s)
                if !have_key 
                  default_value = value.is_a?(Hash) && value.has_key?(:value) ? value[:value] : value
                  model.send(field)[key] = default_value
                else
                  model_value = model.send(field)[key.to_s]
                  if model_value.is_a?(Hash) && !((value.keys - model_value.symbolize_keys.keys).count == 0)
                    model.send(field)[key.to_s] = {
                      **value.symbolize_keys,
                      **model_value.symbolize_keys
                    }
                  end
                end
              end   
            end
            model.save if !model.changes.blank?
          end
        end
      end
  end
end