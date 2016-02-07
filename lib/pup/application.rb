require "rack"
require "pup/dependencies/controller"
require "pup/utilities/string"
require "pup/utilities/object"

module Pup
  class Application
    attr_reader :request, :verb, :path
    def call(env)
      # [200, {}, ["pup: A Ruby Framework for web masters"]]
      # @request = Rack::Request.new(env)
      # @verb, @path = request.request_method, request.path_info
      controller_name, action = controller_and_action("my_pages#index")
      controller = controller_name.new(env)
      controller.send(action)

      unless controller.get_response
        controller.render(action)
      end
      controller.get_response
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
