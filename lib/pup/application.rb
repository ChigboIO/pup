require "rack"
require "pup/dependencies/string"
require "pup/dependencies/object"

module Pup
  class Application
    attr_reader :request, :verb, :path
    def call(_env)
      # [200, {}, ["pup: A Ruby Framework for web masters"]]
      # @request = Rack::Request.new(env)
      # @verb, @path = request.request_method, request.path_info
      controller, action = controller_and_action("pages#index")
      response = controller.new.send(action)
      [200, { "Content-Type" => "text/html" }, [response]]
    end

    def controller_and_action(to)
      controller, action = to.split("#")
      [make_constant(controller), action]
    end

    def make_constant(controller_string)
      controller_class = controller_string.to_camelcase + "Controller"
      Object.const_get(controller_class)
    end
  end
end
