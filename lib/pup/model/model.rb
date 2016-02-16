require "sqlite3"
require "pup/model/columns_builder"
require "pup/model/orm_methods"

module Pup
  class Model
    extend Pup::ColumnsBuilder
    extend Pup::OrmMethods

    DB ||= SQLite3::Database.new(File.join("db", "data.sqlite"))

    def initialize
    end

    def save
      if id
        query = "UPDATE #{self.class.table_name} "\
                "SET #{update_field_set} "\
                "WHERE id = ?"
        DB.execute(query, table_values, id)
      else
        query = "INSERT INTO #{self.class.table_name} "\
                "(#{table_fields}) "\
                "VALUES(#{values_placeholders})"
        DB.execute(query, table_values)
      end
    end

    def destroy
      DB.execute("DELETE FROM #{self.class.table_name} WHERE id= ?", id)
    end

    def table_fields
      columns_except_id.join(", ")
    end

    def columns_except_id
      self.class.columns_array.without_id.with_value(self)
    end

    def values_placeholders
      count = columns_except_id.count
      (["?"] * count).join(", ")
    end

    def table_values
      values = []
      columns_except_id.each do |field|
        values << send(field)
      end
      values
    end

    def update_field_set
      values = []
      columns_except_id.each do |field|
        values << "#{field} = ? "
      end
      values.join(", ")
    end

    class << self
      attr_reader :table_name, :fields

      def to_table(table_name)
        @table_name = table_name.to_s
        @fields = {}
        property :id, type: :integer, primary_key: true
      end

      def property(field_name, options = {})
        @fields[field_name] = options
        attr_accessor field_name
      end

      def create_table
        query = "CREATE TABLE IF NOT EXISTS #{@table_name}"\
                "(#{fields_builder(@fields)})"
        DB.execute(query)
      end

      def columns_array
        @columns_array ||= fields.keys
      end
    end

    private :table_fields, :columns_except_id, :values_placeholders,
            :table_values, :update_field_set
  end
end
