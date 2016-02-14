require "pup/routing/route"
require "pup/routing/route_helpers"

module Pup
  module Routing
    class Router
      include RouteHelpers
      attr_accessor :routes

      ALLOWED_VERBS = %w(get post put patch delete).freeze

      def initialize
        @routes = {}
        generate_verb_methods
      end

      def create(&block)
        instance_eval(&block)
      end

      def has_routes?
        true unless routes.empty?
      end

      def get_match(verb, path)
        verb = verb.downcase.to_sym
        routes[verb].detect do |route|
          route.check_path(path)
        end
      end

      def generate_verb_methods
        self.class.instance_eval do
          ALLOWED_VERBS.each do |verb|
            define_method(verb) do |path, to:|
              process_and_store_route(verb, path, to)
            end
          end
        end
      end

      def process_and_store_route(verb, path, to)
        regex_match, url_placeholders = extract_regex_and_placeholders(path)
        path_regex = convert_path_to_regex(regex_match)
        route_object = Pup::Routing::Route.new(path_regex, to, url_placeholders)

        routes[verb.downcase.to_sym] ||= []
        routes[verb.downcase.to_sym] << route_object
      end

      def extract_regex_and_placeholders(path)
        path.sanitize_path!

        regex_match = []
        url_placeholders = {}
        path.split("/").each_with_index do |element, index|
          if element.start_with?(":")
            url_placeholders[index] = element.delete(":").to_sym
            regex_match << "[a-zA-Z0-9_]+"
          else
            regex_match << element
          end
        end
        [regex_match, url_placeholders]
      end

      def convert_path_to_regex(regex_match)
        regex_string = "^" + regex_match.join("/") + "/*$"
        Regexp.new(regex_string)
      end

      private :generate_verb_methods, :process_and_store_route,
              :extract_regex_and_placeholders, :convert_path_to_regex
    end
  end
end
