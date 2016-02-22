require "spec_helper"
require "rack"
require "unit/factory/tests_controller"

describe Pup::BaseController do
  let(:env) do
    {
      "REQUEST_PATH" => "/pages/:page_id",
      "REQUEST_METHOD" => "GET",
      "rack.input" => ""
    }
  end

  let(:request) { Rack::Request.new(env) }
  let(:controller) do
    cont = TestsController.new(request)
    allow(cont).to receive(:get_template) { "welcome <%= @name %>" }
    cont.send("index")
    cont.render("index")
    cont
  end

  it "has a valid subclass" do
    expect(controller).to be_a Pup::BaseController
  end

  it "responds to the instance methods" do
    expect(controller).to respond_to(:get_response, :render)
  end

  it "responds to the private instance methods", :private do
    expect(controller).to respond_to(
      :get_template, :build_view_params, :make_response, :params,
      :redirect_to, :controller_name
    )
  end

  context "when calling the methods" do
    describe "#get_response" do
      it "returns the rack response" do
        expect(controller.get_response).to be_a Rack::Response
      end

      it "return the correct response attribute" do
        expect(controller.get_response.body).to eq(["welcome Emmanuel"])
        expect(controller.get_response.header).to be_a Hash
        expect(controller.get_response.status).to eq(200)
      end
    end

    describe "#params", :private do
      it "returns a params hash" do
        expect(controller.params).to be_a Hash
      end
    end

    describe "instance variables" do
      it "contains '@name' object created in the index action" do
        expect(controller.instance_variable_get(:@name)).to eq("Emmanuel")
      end
    end

    describe "#redirect_to", :private do
      it "returns the rack response" do
        expect(controller.redirect_to("/inbox")).to be_a Rack::Response
      end

      it "return a 302 redirect response" do
        expect(controller.redirect_to("/inbox").body).to eq([])
        expect(controller.redirect_to("/inbox").header).to be_a Hash
        expect(controller.redirect_to("/inbox").header).to include("Location")
        expect(controller.redirect_to("/inbox").header["Location"]).
          to eq("/inbox")
        expect(controller.redirect_to("/inbox").status).to eq(302)
      end
    end

    describe "#controller_name", :private do
      it "returns a controller's name in snake case without the 'Controller'" do
        expect(controller.controller_name).to eq("tests")
      end
    end

    describe "#request" do
      it { expect(controller.request).to eq(request) }
    end
  end
end
