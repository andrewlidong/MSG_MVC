# MSG MVC
MSG MVC is a lightweight MVC Framework inspired by Ruby on Rails. 

Functionality:
* Interact with the database through a SQLObject
* Query the database with methods such as all and where
* Build associations that use joins

## SQLObject
The RayquazaORM library uses a class, SQLObject that interacts with the database.  

1. SQLObject can return an array of all records in the database

2. SQLObject can look up a single record by primary key

3. SQLObject can insert new rows and update rows with appropriate id.  

## SQLObject

#### `table_name`
Gets the name of the table for a class.  

#### `table_name=`
Sets the name of a table.  In the absence of an explicitly set table name, table_name= by default converts the class name to snake_case and pluralizes.  

Example:
```rb
class Pokemon < SQLObject
end

Pokemon.table_name # => "pokemon"
```

#### `initialize`
Takes in a single params hash that iterates through each of the `attr_name, value` pairs.  

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