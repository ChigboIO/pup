require "spec_helper"
require "unit/factory/router_factory"

RSpec.describe Pup::Application do
  let(:env) do
    {
      "REQUEST_PATH" => "/pages/:page_id",
      "REQUEST_METHOD" => "GET",
      "rack.input" => ""
    }
  end

  let(:router) { RouterFactory.new }
  subject do
    allow_any_instance_of(Pup::BaseController).
      to receive(:get_template) { "welcome" }

    app = Pup::Application.new
    app
  end

  it "responds to the 'call' method" do
    expect(subject).to respond_to(:call)
  end

  describe "response to instance methods", :private do
    it { expect(subject).to respond_to(:respond_to_request) }
    it { expect(subject).to respond_to(:pup_default_response) }
    it { expect(subject).to respond_to(:page_not_found) }
  end

  describe "#call" do
    context "when no route is set in the application router" do
      let(:app) { subject.call(env) }

      it { expect(app).to be_a(Rack::Response) }
    end

    context "when a router is set in the application router" do
      let(:app) do
        subject.instance_variable_set("@router", router)
        subject.call(env)
      end

      it { expect(app).to be_a(Rack::Response) }
    end
  end

  describe "#pup_default_response", :private do
    let(:response) { subject.pup_default_response }

    it { expect(response.status).to eq(200) }
    it { expect(response.headers["Content-Type"]).to eq("text/html") }
  end

  describe "#page_not_found", :private do
    let(:response) { subject.page_not_found }

    it { expect(response.status).to eq(404) }
    it { expect(response.headers["Content-Type"]).to eq("text/html") }
  end
end
