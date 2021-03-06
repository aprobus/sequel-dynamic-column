# Sequel Dynamic Column

A Sequel plugin that adds seamless dynamic columns.

### Description

If you have a serialized column, such as JSON, where you store all of your extra attributes you end up with:
```ruby
spice = SpiceData[2]
spice.json_column['price'] = 4
spice.json_column['color'] = "red"
spice.save
```

With sequel dynamic column you can do:
```ruby
spice = SpiceData[2]
spice.price = 4
spice.color = "red"
spice.save
```
and even better:
```ruby
spice = SpiceData[2]
spice.set(price: 4, color: "red")
spice.save
```

#### Configuring Your Models
```ruby
class SpiceData < Sequel::Model(:spices)
  # Columns: id(integer), name(string), json_fields(json)
  plugin :sequel_dynamic_column do |c|
    c.storage_column = :json_fields
    c.dynamic_columns = :price, :color
  end
end
```
storage_column: The serialized column

dynamic_columns: Columns that are stored in the serialized column

#### Updating Values
Dynamic columns should work with all sequel methods for mass assignment:
```ruby
SpiceData.new(name: 'basil', price: 2)
SpiceData.create(name: 'pepper', price: 3)
SpiceData[1].set(name: 'salt', price: 1)
SpiceData[1].update(name: 'curry', price: 5)
```

As well as adding single attribute setters:
```ruby
SpiceData[1].price = 4
```

#### Getting Values

Dynamic columns can be retrieved directly:
```ruby
SpiceData[1].price # 4
```

And rows can be converted to a hash:
```ruby
# Before
SpiceData[1].to_hash # { id: 1, name: 'salt', json_fields: { 'price' => 2 } }
# After
SpiceData[1].to_extended_hash # { id: 1, name: 'basil', price: 2 }
```

### Version

0.0.1

### Installation

Add to your gem file:
```ruby
gem 'sequel-dynamic-column'
```

### License

MIT

