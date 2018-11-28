require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions 
   attr_accessor(
      :foreign_key,
      :class_name,
      :primary_key
   )

   def model_class 
   end 

   def table_name 
   end 

end 

class BelongsToOptions < AssocOptions 
   def initialize(name, options = {})
   end 
end 

class HasManyOptions < AssocOptions 
   def initialize(name, self_class_name, options)
   end 
end 

module Associatable 
   
   def belongs_to(name, options = {})
   end
   
   def has_many(name, options = {})
   end

   def assoc_options 
   end

end

class SQLObject
end 
