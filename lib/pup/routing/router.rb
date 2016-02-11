require "pup/routing/route"
require "pup/routing/route_helpers"

module Pup
  module Routing
    class Router
      include RouteHelpers
      attr_accessor :routes
      ALLOWED_VERBS = %w(get post put delete patch).freeze

      def initialize
        @routes = {}
        generate_verb_methods
      end

      def create(&block)
        instance_eval(&block)
      end

      def generate_verb_methods
        self.class.instance_eval do
          ALLOWED_VERBS.each do |verb|
            define_method(verb) do |path, to:|
              process_and_save_route(verb, path, to)
            end
          end
        end
      end

      def process_and_save_route(verb, path, to)
        regex_match, url_placeholders = extract_url_placeholders(path)
        path_regex = convert_path_to_regex(regex_match)
        route_object = Pup::Routing::Route.new(path_regex, to, url_placeholders)

        routes[verb.downcase.to_sym] ||= []
        routes[verb.downcase.to_sym] << route_object
      end

      def extract_url_placeholders(path)
        path = "/" + path if path[0] != "/"
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
    end
  end
end
