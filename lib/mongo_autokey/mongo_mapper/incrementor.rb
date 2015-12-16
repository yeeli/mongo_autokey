module Mongo
  module Autokey
    module MongoMapper
      class Incrementor
        def initialize(collection, name, default_number = nil)
          @db = ::MongoMapper.database
          @collection = collection.downcase.to_s
          @ns = "#{@db.name}.#{@collection}"
          @key = "#{@collection}.#{name.to_s}"
          @default_number = default_number || 0 
          exists? || create
        end

        def current
          collection.find_one(query)["auto_increment"]
        end

        def inc
          update_modify("$inc" => { auto_increment: 1 })
        end

        def set(number)
          update_modify("$set" => { auto_increment: number })
        end

        private

        def query
          { ns: @ns, _id: @key }
        end

        def update_modify(mongo_func)
          opts = { query: query, update: mongo_func, new: true }
          collection.find_and_modify(opts)["auto_increment"]
        end

        def collection
          @db['schema.autokey'] 
        end

        def exists?
          collection.find(query).count > 0
        end

        def create
          collection.insert(query.merge({ auto_increment: @default_number.to_i + 1}))
        end
      end
    end
  end
end
