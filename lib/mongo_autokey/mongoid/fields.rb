Mongoid::Fields.option(:auto_increment) do |_model, field, value|
  field.options[:auto_increment] = value
end
