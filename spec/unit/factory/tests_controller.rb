require "pup/utilities/string"
require "pup/controller/base_controller"

class TestsController < Pup::BaseController
  def index
    @name = "Emmanuel"
  end
end
