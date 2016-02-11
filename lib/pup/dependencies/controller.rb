require "erubis"

module Pup
  class Controller
    attr_reader :request, :response

    def initialize(request)
      @request ||= request
    end

    def params
      request.params
    end

    def make_response(body)
      @response = Rack::Response.new(body, 200, "Content-Type" => "text/html")
    end

    def get_response
      @response
    end

    def render(*args)
      response_body = render_template(*args)
      make_response(response_body)
    end

    def render_template(view_name, locals = {})
      template = get_template(view_name)
      parameters = build_view_params(locals)
      Erubis::Eruby.new(template).result(parameters)
    end

    def get_template(view_name)
      filename = File.join("app", "views", controller_name, "#{view_name}.erb")
      File.read(filename)
    end

    def build_view_params(locals)
      vars = {}
      instance_variables.each do |var|
        key = var # .to_s.delete("@").to_sym
        vars[key] = instance_variable_get(var)
      end
      vars.merge(locals)
    end

    def controller_name
      self.class.to_s.gsub("Controller", "").to_snakecase
    end
  end
end
