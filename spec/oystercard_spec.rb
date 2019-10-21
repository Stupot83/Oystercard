require "Oystercard"

describe Oystercard do

    let(:oystercard) { Oystercard.new }

  it("should instantiate the Oystercard class") do
    expect(oystercard).to be_instance_of(Oystercard)
  end

  it "should initialize with a balance of zero" do
    expect(oystercard.balance).to eq(0)
  end

  describe "#top_up" do
    it { is_expected.to respond_to(:top_up).with(1).argument }
    it "can top up the balance" do
        expect { oystercard.top_up 1 }.to change { oystercard.balance }.by 1
      end
  end

  it "has a default maximum balance of £90" do
    maximum_balance = Oystercard::MAXIMUM_BALANCE
    oystercard.top_up(maximum_balance)
    expect{ oystercard.top_up 1 }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
  end

  it "is initially not in a journey" do
    expect(oystercard).not_to be_in_journey
  end

  it "can touch in" do
    oystercard.top_up(1)
    oystercard.touch_in
    expect(oystercard).to be_in_journey
  end

  it "can touch out" do
    oystercard.top_up(1)
    oystercard.touch_in
    oystercard.touch_out
    expect(oystercard).not_to be_in_journey
  end

  it "Raises an error if balance is low" do
    expect{ oystercard.touch_in }.to raise_error "Insufficient balance to touch in"
  end

  it "can deduct from the balance when touching out" do
    expect { oystercard.touch_out }.to change{ oystercard.balance }.by(-Oystercard::MINIMUM_CHARGE) 
  end
end
