require "pup/routing/route"

class RouteFactory < Pup::Routing::Route
  def initialize
    path_regex = Regexp.new("/pages/[a-zA-Z0-9_]+")
    to = "pages#index"
    url_placeholder = { 2 => "id" }

    super(path_regex, to, url_placeholder)
  end
end
