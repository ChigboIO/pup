require "spec_helper"

RSpec.describe Pup::Application do
  subject { Pup::Application.new }

  it "responds to the 'call' method" do
    expect(subject).to respond_to(:call)
  end

  describe ".call" do
    it "returns an array of three objects" do
      # allow(subject).to receive(:controller_and_action)
      # allow(subject).to receive(:new)
      # response = subject.call({})
      # expect(response).to be_an(Array)
      # expect(response.size).to eq(3)
    end
  end
end
