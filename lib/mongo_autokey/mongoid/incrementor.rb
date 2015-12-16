module Mongo
  module Autokey
    module Mongoid
      class Incrementor
        def initialize(collection, name, default_number = nil)
          @client  =  ::Mongoid.default_client
          @collection = collection.downcase.to_s
          @ns = "#{@client.database.name}.#{@collection}"
          @key = "#{@collection}.#{name.to_s}"
          @default_number = default_number || 0 
          exists? || create
        end

        def current
          collection.find(query).first["auto_increment"]
        end

        def inc
          collection.find_one_and_update(query, { "$inc" => { auto_increment: 1 } })
        end

        def set(number)
          collection.find_one_and_update( query, { "$set" => { auto_increment: number }})
        end

        private

        def query
          { ns: @ns, _id: @key }
        end
        
        def collection
          @client['schema.autokey'] 
        end

        def exists?
          collection.find(query).count > 0
        end

        def create
          collection.insert_one(query.merge({ auto_increment: @default_number.to_i + 1}))
        end
      end
    end
  end
end
