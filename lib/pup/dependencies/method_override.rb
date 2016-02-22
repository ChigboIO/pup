require "rack"

class MethodOverride
  def self.apply_to(env)
    request = Rack::Request.new(env)
    env["REQUEST_METHOD"] = request.params["_method"].
                            downcase if request.params["_method"]

    env
  end
end
