require "spec_helper"
require "unit/factory/router_factory"

RSpec.describe Pup::Routing::Router do
  let(:router) { RouterFactory.new }

  it "should have a valid factory" do
    expect(router).to be_a(Pup::Routing::Router)
  end

  it { expect(router.routes).to be_a(Hash) }

  it { expect(router.routes.length).to eq(5) }

  it do
    expect(RouterFactory::ALLOWED_VERBS).to eq(%w(get post put patch delete))
  end

  it { expect(router.has_routes?).to be_truthy }

  it "gets a matching routes for a given path using 'get_match'" do
    path_regex = Regexp.new("^/pages/[a-zA-Z0-9_]+/foo/*$")
    route = Pup::Routing::Route.new(path_regex, "pages#foo", 2 => "id")

    expect(router.get_match("get", "/pages/23/foo")).to eq(route)
  end
end
