module Mongo
  module Autokey
    module Mongoid
      class Criteria < ::Mongoid::Criteria
        private
        def mongoize_ids(ids)
          super
          ids.map{ |id| convert_object_id(id) }
        end

        def convert_object_id(value)
          return value if value.is_a?(BSON::ObjectId)
          return nil   if value.nil? || (value.respond_to?(:empty?) && value.empty?)
          return value if value.is_a?(Integer)
          if BSON::ObjectId.legal?(value.to_s)
            BSON::ObjectId.from_string(value.to_s)
          elsif value.is_a?(Integer) || value.to_s.match(/^\d+$/)
            value.to_i
          else
            value
          end
        end
      end
    end
  end
end
