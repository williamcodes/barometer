require_relative '../spec_helper'

RSpec.describe Barometer::Utils::VersionedRegistration do
  describe "#register" do
    let(:registrations) { Barometer::Utils::VersionedRegistration.new }

    it "treats no version as nil" do
      expect {
        registrations.register(:foo, double(:bar))
      }.to change{ registrations.size }.by(1)
    end

    it "will register for the given key" do
      expect {
        registrations.register(:foo, :v1, double(:bar))
      }.to change{ registrations.size }.by(1)
    end

    it "will not register the same key/version combination" do
      registrations.register(:foo, :v1, double(:bar))

      expect {
        registrations.register(:foo, :v1, double(:bar))
      }.not_to change{ registrations.size }
    end

    it "will not register the same key with default version" do
      registrations.register(:foo, nil, double(:bar))

      expect {
        registrations.register(:foo, nil, double(:bar))
      }.not_to change{ registrations.size }
    end

    it "will register a the same key but unique version" do
      registrations.register(:foo, :v1, double(:bar))

      expect {
        registrations.register(:foo, :v2, double(:bar))
      }.to change{ registrations.size }.by(1)
    end

    it "registers a block without a version" do
      registration = Proc.new do
      end

      registrations.register(:foo, &registration)
      expect(registrations.find(:foo)).to eq registration
    end

    it "registers a block with a version" do
      registration = Proc.new do
      end

      registrations.register(:foo, :v1, &registration)
      expect(registrations.find(:foo, :v1)).to eq registration
    end
  end

  describe "#find" do
    let(:registrations) { Barometer::Utils::VersionedRegistration.new }

    it "finds the registration with no version by default" do
      registration = double(:bar)
      registrations.register(:foo, nil, registration)

      expect(registrations.find(:foo)).to eq registration
      expect(registrations.find(:foo, :v1)).to eq registration
    end

    it "finds the matching registration" do
      registration_default = double(:bar_default)
      registration_v1 = double(:bar_v1)
      registration_v2 = double(:bar_v2)
      registrations.register(:foo, nil, registration_default)
      registrations.register(:foo, :v1, registration_v1)
      registrations.register(:foo, :v2, registration_v2)

      expect(registrations.find(:foo, :v1)).to eq registration_v1
      expect(registrations.find(:foo, :v2)).to eq registration_v2
    end

    it "returns nothing if requested key not found" do
      registrations.register(:foo, nil, double(:bar))
      expect(registrations.find(:bar, :v1)).to be_nil
    end

    it "returns nothing if requested version not found" do
      registrations.register(:foo, :v1, double(:bar))
      expect(registrations.find(:foo, :v2)).to be_nil
    end
  end

  describe "#size" do
    let(:registration) { double(:registration) }
    let(:registrations) { Barometer::Utils::VersionedRegistration.new }

    it "counts versions" do
      registrations.register(:foo, nil, registration)
      registrations.register(:foo, :v1, registration)
      registrations.register(:bar, :v1, registration)
      expect(registrations.size).to eq 3
    end
  end
end
