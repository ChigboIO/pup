require "pup/model/model"

class ModelFactory < Pup::Model
  to_table :users

  property :name, type: :varchar, nullable: false
  property :age, type: :integer, default: 21

  create_table
end
