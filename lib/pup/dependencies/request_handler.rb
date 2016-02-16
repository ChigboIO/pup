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
      route_url_params = route.get_url_parameters(request.path_info)
      request.params.merge(route_url_params)
    rescue RuntimeError
      {}.merge(route_url_params)
    end

    def controller_response(controller, action)
      controller.send(action)

      unless controller.get_response
        controller.render(action)
      end
      controller.get_response
    end

    private :process_request, :collage_parameters, :controller_response
  end
end
