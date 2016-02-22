require "spec_helper"

describe Array do
  it "should respond to 'with_value'" do
    expect(Array.new).to respond_to(:with_value)
  end

  it "should respond to 'without_id'" do
    expect(Array.new).to respond_to(:without_id)
  end

  describe ".without_id" do
    hash = [:name, :id, :age]
    it { expect(hash.without_id).to eq([:name, :age]) }
  end

  describe ".with_value" do
  end
end
