require "rack"

module Pup
  class Application
    def self.call(_env)
      [200, {}, ["pup: A Ruby Framework for web masters"]]
    end
  end
end
