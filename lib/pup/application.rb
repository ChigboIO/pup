require "rack"
require "pup/dependencies/controller"
require "pup/utilities/string"
require "pup/utilities/object"
require "pup/routing/router"
require "pup/dependencies/request_handler"

module Pup
  class Application
    attr_reader :request, :verb, :path

    def initialize
      @router = Routing::Router.new
    end

    def call(env)
      @request = Rack::Request.new(env)
      route = match_route

      if route
        handler = RequestHandler.new(request, route)
        handler.response
      else
        pup_default_response
      end
    end

    def match_route
      verb = request.request_method.downcase.to_sym
      # require "pry"; binding.pry
      @router.routes[verb].detect do |route|
        route.check_path(request.path_info)
      end
    end

    def pup_default_response
      Rack::Response.new(
        "Pup ::: Framework for web masters",
        200,
        "Content-Type" => "text/html"
      )
    end

    def routes
      @router
    end
  end
end
