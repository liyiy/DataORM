require_relative 'db_connection'
require_relative 'sql_object'


module Searchable
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
end

class SQLObject
   extend Searchable
end