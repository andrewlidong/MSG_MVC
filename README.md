# MSG MVC
MSG MVC is a lightweight MVC Framework inspired by Ruby on Rails. 

Functionality:
* Rayquaza ORM
* Basic Search Functions
* Model Associations 
* Controllers with flash and session functionality
* CSRF attack protection
* Regex routing
* Middleware
* Server Integration

## ORM
MSG MVC incorporates all the functionality of RayquazaORM, a lightweight Object Relational Mapping system that supports PostgreSQL queries.  For more, see [RayquazaORM](https://github.com/andrewlidong/RayquazaORM)

1. Basic search functions such as all and find

2. Insert and update values

3. Build associations such as has_many, belongs_to and has_one_through

## Flash and Session Functions

#### `flash`
Returns a hash-like object that is available for the current and next request cycle.  Receives a request and retrieves its contents from a cookie.  

#### `flash.now`
Returns a hash-like object that is available for the current cycle.  

Example:
```rb
class Flash
  attr_reader :now

  def initialize(req)
    cookie = req.cookies['_rails_lite_app_flash']

    @now = cookie ? JSON.parse(cookie) : {}
    @flash = {}
  end

  def [](key)
    @now[key.to_s] || @flash[key.to_s]
  end

  def []=(key, value)
    @flash[key.to_s] = value
  end

  def store_flash(res)
    res.set_cookie('_rails_lite_app_flash', value: @flash.to_json, path: '/')
  end
end
```

#### `Middleware`
Middleware returns properly formatted errors.  Specifically, ours renders the following:

* The stack trace
* A preview of the source code where the exception was raised
* The exception message

Example: 

```rb
lugia = Pokemon.new(name: "Hobbes", trainer_id: 123)
lugia.name #=> "Hobbes"
lugia.trainer_id #=> 123
```
## Queries

#### `all`

Fetches all records from the database.  

Example: 

```rb
class Pokemon < SQLObject
  finalize!
end

Pokemon.all
# SELECT
#   pokemon.*
# FROM
#   pokemon

class PokemonTrainer < SQLObject
  self.table_name = "pokemon_trainers"

  finalize!
end

PokemonTrainer.all
# SELECT
#   pokemon_trainers.*
# FROM
#   pokemon_trainers

class Pokemon < SQLObject
  self.table_name = "pokemon"

  finalize!
end

Pokemon.all
=> [#<Pokemon:0x007fa409ceee38
  @attributes={:id=>1, :name=>"Hobbes", :trainer_id=>1}>,
 #<Pokemon:0x007fa409cee988
  @attributes={:id=>2, :name=>"Smith", :trainer_id=>1}>,
 #<Pokemon:0x007fa409cee528
  @attributes={:id=>3, :name=>"Kant", :trainer_id=>2}>]
```

#### `find( id )`

Returns a single object with the given id.  

#### `insert( value )`

Inserts values into table name.  

Example:

```rb
INSERT INTO
  table_name (col1, col2, col3)
VALUES
  (?, ?, ?)
```

#### `update( id, value )`

Updates a record's attributes

Example: 

```rb
UPDATE
  table_name
SET
  col1 = ?, col2 = ?, col3 = ?
WHERE
  id = ?
```

#### `save`

Calls insert or update depending on whether an id is passed or not.  

## Associatable

A module that has methods such as belongs_to and has_many that will be mixed into SQLObject

#### `belongs_to`

Takes in an association name and an options hash, builds an association.  

#### `has_many`

Takes in an association and an options hash, builds an association.  

#### `has_one_through`

Takes an association and an options hash, builds association between models through the use of a joins table.  