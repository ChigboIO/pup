require "spec_helper"
require "rack"
require "pup/dependencies/request_handler"
require "unit/factory/route_factory"

describe Pup::RequestHandler do
  let(:env) do
    {
      "REQUEST_PATH" => "/pages/:page_id",
      "REQUEST_METHOD" => "GET",
      "rack.input" => ""
    }
  end

  let(:request) { Rack::Request.new(env) }
  let(:route) { RouteFactory.new }
  let(:handler) do
    allow_any_instance_of(Pup::BaseController).
      to receive(:get_template) { "welcome" }

    Pup::RequestHandler.new(request, route)
  end

  it "is a valid RequestHelper" do
    expect(handler).to be_a Pup::RequestHandler
  end

  it "responds to the instance methods" do
    expect(handler).to respond_to(:response)
  end

  it "responds to the private instance methods", :private do
    expect(handler).to respond_to(
      :process_request, :collage_parameters, :controller_response
    )
  end

  describe "#response" do
    it "should return a rack object" do
      expect(handler.response).to be_a(Rack::Response)
    end

    it "should return a successful response message" do
      expect(handler.response.body).to eq(["welcome"])
      expect(handler.response.status).to eq(200)
      expect(handler.response.header).to be_a Hash
    end
  end

  describe "#request" do
    it { expect(handler.request).to eq(request) }
  end

  describe "#route" do
    it { expect(handler.route).to eq(route) }
  end
end
