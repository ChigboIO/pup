require "pup/routing/route"
require "pup/routing/route_helpers"

module Pup
  module Routing
    class Router
      include RouteHelpers
      attr_accessor :routes, :url_placeholders, :part_regex

      ALLOWED_VERBS = %w(get post put patch delete).freeze

      def initialize
        @routes = {}
        @url_placeholders = {}
        @part_regex = []
        generate_verb_methods
      end

      def create(&block)
        instance_eval(&block)
      end

      def has_routes?
        true unless routes.empty?
      end

      def get_match(verb, path)
        verb = verb.downcase
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
        regex_parts, url_placeholders = extract_regex_and_placeholders(path)
        path_regex = convert_regex_parts_to_path(regex_parts)
        route_object = Pup::Routing::Route.new(path_regex, to, url_placeholders)

        routes[verb.downcase.freeze] ||= []
        routes[verb.downcase] << route_object
      end

      def extract_regex_and_placeholders(path)
        path.sanitize_path!

        self.part_regex = []
        self.url_placeholders = {}
        path.split("/").each_with_index do |path_part, index|
          store_part_and_placeholder(path_part, index)
        end

        [part_regex, url_placeholders]
      end

      def store_part_and_placeholder(path_part, index)
        if path_part.start_with?(":")
          url_placeholders[index] = path_part.delete(":").freeze
          part_regex << "[a-zA-Z0-9_]+"
        else
          part_regex << path_part
        end
      end

      def convert_regex_parts_to_path(regex_match)
        regex_string = "^" + regex_match.join("/") + "/*$"
        Regexp.new(regex_string)
      end

      private :generate_verb_methods, :process_and_store_route,
              :extract_regex_and_placeholders, :convert_regex_parts_to_path,
              :store_part_and_placeholder
    end
  end
end
