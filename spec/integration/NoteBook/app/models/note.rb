class Note < Pup::Model
  to_table :notes
  # property :id, type: :integer, primary_key: true
  property :title, type: :varchar, nullable: false
  property :category, type: :varchar, default: "unclassified"
  property :content, type: :text
  property :created_at, type: :datetime
  property :updated_at, type: :datetime

  create_table
end
