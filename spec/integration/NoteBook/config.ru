APP_ROOT ||= __dir__

require File.expand_path("../config/application", __FILE__)

PupApplication ||= NoteBook::Application.new
require_relative "config/routes.rb"

app ||= Rack::Builder.new do
  use Rack::Reloader
  use Rack::Static, urls: ["/stylesheets", "/images", "/javascripts"],
                    root: "app/assets"

  run PupApplication
end

run app
