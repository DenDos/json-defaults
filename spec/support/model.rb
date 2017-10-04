load File.dirname(__FILE__) + '/schema.rb'

class User < ActiveRecord::Base
  extend JsonDefaults
  
  json_defaults(
    field: "params", 
    options: {
      name: "Denis",
      programmer: {
        value: true,
        boolean: true
      },
      age: {
        value: 25,
        integer: true
      },
      data: {
        field1: 'field1',
        field2: 'field2',
      }

    }
  )

end