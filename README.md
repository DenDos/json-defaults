# JsonDefaults

Very simple library for defining default options for your object.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_defaults'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_defaults

## Usage

Working with Model
------------------------

- Create jsonb field for you model:

```ruby
rails g migration add_json_field_to_users json_field:jsonb
rake db:migrate
```

- Add this to your model:

```ruby
class User < ActiveRecord::Base
  extend JsonDefaults
  
  json_defaults(
    field: "json_field", 
    options: {
      field1: "It's",
      field2: "awesome"
    }
  )
end
```
And next just use defined fields with default options

```ruby
user = User.new
user.json_field # => {"field1"=>"It's", "field2"=>"awesome"}
user.field1 # => It's
user.field2 # => awesome
```
You can update this field directly

```ruby
user = User.new
user.field1 # => It's
user.field1 = "cool" 
user.field1 # => cool
```

- You can also define type for each field:

```ruby
class User < ActiveRecord::Base
  extend JsonDefaults
  
  json_defaults(
    field: "json_field", 
    options: {
      field1: "It's",
      field2: "awesome",
      field3: {
        value: false,
        boolean: true
      },
      field4: {
        value: 666,
        integer: true
      }
    }
  )
end
```

```ruby
user = User.new
user.field4 # => 666
user.field4 = "123" 
user.field4 # => 123
```

### Options for defining field

```ruby
  json_defaults(
    field: "json_field", 
    options: {
      key: "value",
      key: {
        value: 666,
        integer: true
      }
    }
  )
```

| Option | type | Description |
| :--- | :--- | :--- |
| `field` |String| This parameter specifies which field in the model the json_defaults plugin will be applied to. |
| `options` |Hash| Default hash for selected field with ```key``` and ```value``` |
| `key` || Key's name in default hash. Can be ```string``` or ```symbol```|

