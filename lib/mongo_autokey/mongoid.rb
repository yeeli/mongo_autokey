require 'mongo_autokey/mongoid/fields'
require "mongo_autokey/mongoid/incrementor"

module Mongoid
  module Autokey
    extend ActiveSupport::Concern
    
    included do
      before_create :auto_increment_from_mongoid
    end

    module ClassMethods
      def auto_increment_key( name = nil, options = {})
        if name.nil?
          field_name = 'id'
        else
          field name.to_sym
          field_name = name.to_s
        end
        default_number = options[:default]
        before_create :id_auto_increment
        class_eval <<-RUBY
          def id_auto_increment
            incrementor = Mongo::Autokey::Mongoid::Incrementor.new('#{self.model_name.collection}', '#{field_name}', #{default_number})
            self.#{field_name} = incrementor.current
            incrementor.inc
          end
        RUBY
      end
    end

    private

    def auto_increment_from_mongoid
      auto_key = {}
      self.fields.each do |key, value|
        options = value.options
        if value.options.has_key?(:auto_increment)
          auto_key[key] = options[:default] if options[:auto_increment]
        end
      end
      auto_key.each do |k, v|
        incrementor = Mongo::Autokey::Mongoid::Incrementor.new( self.class.model_name.collection, k, v)
        self.send k + "=", incrementor.current 
        incrementor.inc
      end
    end
  end
end
