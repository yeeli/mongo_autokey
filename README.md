# MongoAutokey

It's a mongo_mapper or mongoid plugin add incremented id in Mongomapper

## Installation

Add this line to your application's Gemfile:

```
gem 'mongo_autokey'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongo_autokey

## Usage

auto increment with id

```
  class Product
    include MongoMapper::Document
    include MongoMapper::AutoKey
    
    auto_increment_key
    key :title, String
  end
```

auto increment without id

```
  class Product
    include MongoMapper::Document
    include MongoMapper::AutoKey
    
    auto_increment_key :other_id
    key :sku, Integer, auto_increment: true
  end
```

set default value

```
  class Product
    include MongoMapper::Document
    include MongoMapper::AutoKey
    
    auto_increment_key default: 100000
    auto_increment_key :id2, default: 100000
    key :sku, Integer, auto_increment: true, default: 100000
  end
 ```
 
## License

Copyright © 2015, Ye Li. Released under the MIT License
 
