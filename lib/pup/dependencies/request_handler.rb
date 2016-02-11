module Pup
  class RequestHandler
    attr_reader :request, :route, :response

    def initialize(request, route)
      @request = request
      @route = route
      process_request
    end

    def process_request
      params = collage_parameters

      request.instance_variable_set "@params", params

      controller_constant = route.controller
      controller_class = controller_constant.new(request)

      @response = controller_response(controller_class, route.action.to_sym)
    end

    def collage_parameters
      request.params.merge(route.get_url_parameters(request.path_info))
    rescue RuntimeError
      {}.merge(route.get_url_parameters(request.path_info))
    end

    def controller_response(controller, action)
      controller.send(action)

      unless controller.get_response
        controller.render(action)
      end
      controller.get_response
    end

    def error_response(error)
      Rack::Response.new("Error. #{error}.", 500, {})
    end
  end
end
