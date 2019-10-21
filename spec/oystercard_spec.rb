require "Oystercard"

describe Oystercard do
  it("should instantiate the Oystercard class") do
    expect(subject).to be_instance_of(Oystercard)
  end

  it "should initialize with a balance of zero" do
    expect(subject.balance).to eq(0)
  end
end
