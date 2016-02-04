require "spec_helper"

RSpec.describe Pup::Application do
  subject { Pup::Application }

  it "responds to the 'call' method" do
    expect(subject).to respond_to(:call)
  end

  describe ".call" do
    it "returns an array of three objects" do
      response = subject.call({})
      expect(response).to be_an(Array)
      expect(response.size).to eq(3)
    end
  end
end
