require "pup"

$LOAD_PATH << File.expand_path("../../app/controllers/", __FILE__)
$LOAD_PATH << File.expand_path("../../app/models/", __FILE__)

module NoteBook
  class Application < Pup::Application
  end
end
