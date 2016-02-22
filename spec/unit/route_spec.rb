require "spec_helper"
require "unit/factory/route_factory"

RSpec.describe Pup::Routing::Route do
  let(:route) { RouteFactory.new }

  it "should have a valid factory" do
    expect(route).to be_a(Pup::Routing::Route)
  end

  it { expect(route.controller).to be_a(Class) }

  it { expect(route.controller_name).to eq("pages_controller") }

  it { expect(route.action).to eq("index") }

  it { expect(route.path_regex).to eq(Regexp.new("/pages/[a-zA-Z0-9_]+")) }

  it { expect(route.url_placeholders).to eq(2 => "id") }

  it { expect(route.get_url_parameters("/pages/45")).to eq("id" => "45") }

  it { expect(route.check_path("/pages/45/mo")).to be_truthy }
end
