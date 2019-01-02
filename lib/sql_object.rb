require 'active_support/inflector'

class SQLObject 
   
   def self.columns 
      return @columns if @columns 
      cols = DBConnection.execute2(<<-SQL).first
         SELECT 
            * 
         FROM 
            #{self.table_name}
         LIMIT 
            0
      SQL
      @columns = cols.map{|column| column.to_sym} 
   end 

   def self.finalize!
      self.columns.each do |column|
         define_method(column) do 
            self.attributes[column]
         end

         define_method("#{column}=") do |arg|
            self.attributes[column] = arg 
         end
      end  
   end 

   def self.table_name=(table_name)
      @table_name = table_name 
   end 

   def self.table_name 
      @table_name = "#{self}".downcase + "s"
   end 

   def self.all 
      results = DBConnection.execute(<<-SQL)
         SELECT
            *
         FROM
            #{self.table_name}
      SQL

         self.parse_all(results)
   end 

   def self.parse_all(results)
      list = []
      results.each do |hash|
         list << self.new(hash)
      end 
      list 
   end 

   def self.find(id)
      result = DBConnection.execute(<<-SQL, id: id)[0]
         SELECT 
            * 
         FROM
            #{self.table_name}
         WHERE 
            id = :id 
      SQL 
      return nil if results.nil?
      self.new(result)  

   end 

   def initialize(params = {})
      params.each do |attr_name, value| 
         attr_name = attr_name.to_sym 
         if self.class.columns.include?(attr_name)
            self.send("#{attr_name}=", value)
         else 
            raise "unknown attribute '#{attr_name}'"
         end 
      end 
   end 

   def attributes 
      @attributes ||= {}
   end 

   def attribute_values 
      self.class.columns.map { |attr| self.send(attr) }
   end 

   def insert 
      columns = self.class.columns.drop(1)
      col_names = columns.map(&:to_s).join(", ")
      question_marks = (["?"] * columns.count).join(", ")

      DBConnection.execute(<<-SQL, *attribute_values.drop(1))
         INSERT INTO 
            #{self.class.table_name} (#{col_names})
         VALUES 
            (#{question_marks})
      SQL 

      self.id = DBConnection.last_insert_row_id
   end 

   def update 
      set_line = self.class.columns.map { |attr| "#{attr} = ?"}.join(", ")

      DBConnection.execute(<<-SQL, *attribute_values, id)
         UPDATE 
            #{self.class.table_name}
         SET 
            #{set_line}
         WHERE
            #{self.class.table_name}.id = ?
      SQL
   end 

   def save 
      id.nil? ? insert : update 
   end 

end 
