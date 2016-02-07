require "erubis"

module Pup
  class Controller
    attr_reader :request

    def initialize(env)
      @request ||= Rack::Request.new(env)
    end

    def params
      request.params
    end

    def render(view_name, locals = {})
      template = get_template(view_name)
      Erubis::Eruby.new(template).result(locals)
    end

    def get_template(view_name)
      filename = File.join("app", "views", controller_name, "#{view_name}.erb")
      File.read(filename)
    end

    def controller_name
      self.class.to_s.gsub("Controller", "").to_snakecase
    end
  end
end
