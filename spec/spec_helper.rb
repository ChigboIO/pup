$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift File.expand_path("../../spec", __FILE__)

# require "simplecov"
# SimpleCov.start
require "coveralls"
Coveralls.wear!
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "pup"
require "rack"

RSpec.shared_context "private", private: true do
  before :all do
    described_class.class_eval do
      @private_instance_methods = private_instance_methods
      public(*@private_instance_methods)
    end
  end

  after :all do
    described_class.class_eval do
      private(*@private_instance_methods)
    end
  end
end

RSpec.shared_context type: :feature do
  require "capybara/rspec"

  before(:all) do
    app = Rack::Builder.parse_file(
      "#{__dir__}/integration/NoteBook/config.ru"
    ).first
    Capybara.app = app
  end

  after :all do
    Note::DB.execute("DROP TABLE IF EXISTS notes")
    Note.create_table
  end

  def create_note
    Note.create(
      title: "Test Note",
      content: "Test content",
      category: "unclassified",
      created_at: Time.now.to_s,
      updated_at: Time.now.to_s
    )
  end
end
