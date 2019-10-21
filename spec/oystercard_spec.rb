require "Oystercard"

describe Oystercard do
  it("should instantiate the Oystercard class") do
    expect(subject).to be_instance_of(Oystercard)
  end

  it "should initialize with a balance of zero" do
    expect(subject.balance).to eq(0)
  end

  describe "#top_up" do
    it { is_expected.to respond_to(:top_up).with(1).argument }
  end

  it "can top up the balance" do
    expect { subject.top_up 1 }.to change { subject.balance }.by 1
  end

  it "has a default maximum balance of £90" do
    maximum_balance = Oystercard::MAXIMUM_BALANCE
    subject.top_up(maximum_balance)
    expect{ subject.top_up 1 }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
  end

  describe "#deduct" do
    it { is_expected.to respond_to(:deduct).with(1).argument }
  end

  it "can deduct from the balance" do
    expect { subject.deduct 1 }.to change { subject.balance }.by -1
  end
end
