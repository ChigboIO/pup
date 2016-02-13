require "sqlite3"
require "pup/modeling/columns_builder"

module Pup
  class Model
    extend ColumnsBuilder

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
      self.class.columns_array.no_id.with_value(self).join(", ")
    end

    def values_placeholders
      count = self.class.columns_array.no_id.with_value(self).count
      (["?"] * count).join(", ")
    end

    def table_values
      values = []
      self.class.columns_array.no_id.with_value(self).each do |field|
        values << send(field)
      end
      values
    end

    def update_field_set
      values = []
      self.class.columns_array.no_id.with_value(self).each do |field|
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

      def all
        fields = columns_array.join(", ")
        data = DB.execute("SELECT id, #{fields} FROM #{@table_name}")
        data.map! do |row|
          row_to_model(row)
        end

        data
      end

      def row_to_model(row)
        model = new

        columns_array.each_with_index do |field, index|
          model.send("#{field}=", row[index + 1]) if row
        end

        model
      end

      def find(id)
        fields = columns_array.join(", ")
        row = DB.execute(
          "SELECT id, #{fields} FROM #{table_name} WHERE id = ?",
          id
        ).first
        row_to_model(row)
      end

      def destroy(id)
        DB.execute("DELETE FROM #{table_name} WHERE id= ?", id)
      end

      def destroy_all
        DB.execute("DELETE FROM #{table_name}")
      end
    end
  end
end
