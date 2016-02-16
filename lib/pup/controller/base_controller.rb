require "active_support/core_ext/hash/indifferent_access"
require "erubis"

module Pup
  class BaseController
    attr_reader :request

    def initialize(request)
      @request ||= request
    end

    def get_response
      @response
    end

    def render(view_name, locals = {})
      template = get_template(view_name)
      parameters = build_view_params(locals)
      response_body = Erubis::Eruby.new(template).result(parameters)
      make_response(response_body)
    end

    def get_template(view_name)
      filename = File.join("app", "views", controller_name, "#{view_name}.erb")
      File.read(filename)
    end

    def build_view_params(locals)
      hash = {}
      vars = instance_variables
      vars.each { |name| hash[name] = instance_variable_get(name) }

      hash.merge(locals)
    end

    def make_response(body, status = 200, headers = {})
      @response = Rack::Response.new(body, status, headers)
    end

    def params
      request.params.with_indifferent_access
    end

    def redirect_to(location)
      make_response([], 302, "Location" => location)
    end

    def controller_name
      self.class.to_s.gsub("Controller", "").to_snakecase
    end

    private :get_template, :build_view_params, :make_response, :params,
            :redirect_to, :controller_name
  end
end
