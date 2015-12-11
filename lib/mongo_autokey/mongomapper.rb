require 'mongo_autokey/mongomapper/plucky'

module MongoMapper
  module Autokey
    extend ActiveSupport::Concern

    included do
      before_create :auto_increment_from_mongo_mapper
    end

    module ClassMethods
      def auto_increment_key( name = nil, options = {} )
        if name.nil?
          key_name = 'id'
        else
          key name.to_sym
          key_name = name.to_s
        end
        default_number = options[:default]
        before_create :id_auto_increment
        class_eval <<-RUBY
          def id_auto_increment
            incrementor = Mongo::AutoKey::Incrementor.new('#{self.model_name.collection}', '#{key_name}', #{default_number})
            self.#{key_name} = incrementor.current
            incrementor.inc
          end
        RUBY
      end
    end

    private
    
    def auto_increment_from_mongo_mapper
      auto_key = {}
      keys.each do |k| 
        options = k[1].options
        if options.has_key?(:auto_increment)
          auto_key[k[0]] = options[:default] if options[:auto_increment]
        end
      end
      
      auto_key.each do |k, v| 
        incrementor = Mongo::AutoKey::Incrementor.new(MongoMapper.database, self.class.model_name.collection, k, v)
        self.send k + "=", incrementor.current 
        incrementor.inc
      end
    end
  end
end
