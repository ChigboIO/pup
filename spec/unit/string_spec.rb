require "spec_helper"

describe String do
  it "should respond to 'to_camelcase'" do
    expect(String.new).to respond_to(:to_camelcase)
  end

  it "should respond to 'to_snakecase'" do
    expect(String.new).to respond_to(:to_snakecase)
  end

  it "should respond to 'sanitize_path'" do
    expect(String.new).to respond_to(:sanitize_path!)
  end

  describe ".to_camelcase" do
    name = "pages_controller"
    it { expect(name.to_camelcase).to eq("PagesController") }
  end

  describe ".to_snakecase" do
    name = "PagesController"
    it { expect(name.to_snakecase).to eq("pages_controller") }
  end

  describe ".sanitize_path!" do
    path = "pages/index/"
    path.sanitize_path!
    it { expect(path).to eq("/pages/index") }
  end
end
