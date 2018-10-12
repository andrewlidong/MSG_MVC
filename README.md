# MSG_MVC

## About

MSG_MVC is a lightweight MVC framework built with Ruby.  

## Architecture and Technologies

The project is implemented with the following technologies:

- Technology 1

## Technical Implementation

Some technical highlights of the app are:
1. Metaprogramming methods `define_method`, `instance_variable_get` and `instance_variable_set`

NB: you cannot always infer the name of the table. For example: the inflector library will, by default, pluralize human into humen, not humans. WAT. That's what your ::table_name= is for: so users of SQLObject can override the default, inferred table name.

### Feature 1

Implemented attr_accessor getter and setter methods using `define_method`, `instance_variable_get` and `instance_variable_set`

```ruby
  // from 00_attr_accessor_object.rb

  class AttrAccessorObject
    def self.my_attr_accessor(*names)
      names.each do |name|
        define_method(name) do
          instance_variable_get("@#{name}")
        end

        define_method("#{name}=") do |value|
          instance_variable_set("@#{name}", value)
        end
      end
    end
  end
```

## Future Features
In the future, I plan to add the following features:

*