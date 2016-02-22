module Pup
  module Routing
    class Route
      attr_reader :controller_name, :action, :path_regex, :url_placeholders
      def initialize(path_regex, to, url_placeholders = {})
        @controller_name, @action = get_controller_and_action(to)
        @path_regex = path_regex
        @url_placeholders = url_placeholders
      end

      def get_controller_and_action(to)
        controller, action = to.split("#")
        controller_name = controller + "_controller"
        [controller_name, action]
      end

      def controller
        Object.const_get(controller_name.to_camelcase)
      end

      def get_url_parameters(actual_path)
        parameters = {}
        path = actual_path.split("/")
        url_placeholders.each do |index, key|
          parameters[key] = path[index.to_i]
        end
        parameters
      end

      def check_path(path)
        (path_regex =~ path) == 0
      end

      def ==(other)
        controller_name == other.controller_name &&
          action == other.action &&
          path_regex == other.path_regex &&
          url_placeholders == other.url_placeholders
      end

      private :get_controller_and_action
    end
  end
end
