require "mongo_autokey/version"

if defined?(Mongoid)
  require 'mongo_autokey/mongoid'
elsif defined?(MongoMapper)
  require 'mongo_autokey/mongomapper'
end
