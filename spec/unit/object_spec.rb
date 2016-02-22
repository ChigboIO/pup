require "spec_helper"
require "rack"

describe Object do
  it "should respond to 'with_value'" do
    expect(Object).to respond_to(:const_missing)
  end

  it "gets the constant of a string" do
    expect(Object.const_get("Rack")).to eq(Rack)
  end
end
