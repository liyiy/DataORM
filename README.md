# DataORM
## About
DataORM is an object relational mapping framework inspired by Active Record. It creates a simple to use interface by forming a connection with the database and abstracting away SQL tables into classes and complex queries into methods.


## Instructions 
To check out the Pokemon database demo,
- bundle install
- run pry and then load 'pokemon.rb'

To use DataORM in your projects, require the file 'dataORM.rb' and extend SQLObject onto your model.  

## Methods
- `all` - returns everything from the table
```ruby
def self.all 
   results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
   SQL
   self.parse_all(results)
end 
 ```
- `find` - returns the object with the ID
```ruby 
   def self.find(id)
      result = DBConnection.execute(<<-SQL, id)
         SELECT
         *
         FROM
         #{self.table_name}
         WHERE
         #{self.table_name}.id = ?
      SQL

      parse_all(result).first
   end
```
- `where` - parses into correct SQL syntax and returns results from specific WHERE parameters 
```ruby
   def where(params)
      where_line = params.map do |k, v|
         if v.is_a?(String)
         v = "'#{v}'"
         end
         "#{k.to_s} = #{v}"
      end.join(" AND ")

      result = DBConnection.execute(<<-SQL)
         SELECT
            *
         FROM
            #{self.table_name}
         WHERE
            #{where_line}
      SQL

      result.map {|attributes| self.new(attributes)}
   end
```
- `insert` - inserts new row into SQL database
- `update` - updates the object into SQL database
## Associations
- `belongs_to` - creates an association between two tables with the BelongsTo class
```ruby
   def belongs_to(name, options = {})
      self.assoc_options[name] = BelongsToOptions.new(name, options)

      define_method(name) do 
         options = self.class.assoc_options[name]
         value = self.send(options.foreign_key)
         options.model_class.where(options.primary_key => value).first
      end
   end
```
- `has_many` - creates an association between two tables with the HasMany class
```ruby
   def has_many(name, options = {})
      self.assoc_options[name] = HasManyOptions.new(name, self.name, options)

      define_method(name) do 
         options = self.class.assoc_options[name]
         value = self.send(options.primary_key)
         options.model_class.where(options.foreign_key => value)
      end
   end
```
