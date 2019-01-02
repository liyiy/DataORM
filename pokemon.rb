require 'active_support/inflector'
require 'sqlite3'
require_relative './lib/db_connection'
require_relative './lib/sql_object'
require_relative './lib/searchable'
require_relative './lib/associatable'

DBConnection.open('pokemon.db')

class Pokemon < SQLObject 
   attr_accessor :id, :name, :trainer_id

   belongs_to :trainer 
end 

class Trainer < SQLObject
   attr_accessor :id, :name

   belongs_to :town 

   has_many :pokemons, 
      foreign_key: :trainer_id,
      class_name: 'Pokemon',
      primary_key: :id
   
end 

class Town < SQLObject 
   attr_accessor :id, :name 
   
   has_many :residents,
      class_name: 'Trainer',
      foreign_key: :town_id,
      primary_key: :id
end 

pokemon = Pokemon.all 
trainers = Trainer.all 
towns = Town.all

puts pokemon 
puts trainers 
puts towns 