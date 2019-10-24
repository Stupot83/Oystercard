require 'oystercard'
require 'station'
require 'journey'

describe Oystercard do
  let(:oystercard) { Oystercard.new }
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:journey_log) { double :journey_log }

  min_journey_balance = Journey::MINIMUM_FARE
  penalty_fare = Journey::PENALTY_FARE

  describe 'defaults' do
    it 'should instantiate the Oystercard class' do
      expect(oystercard).to be_instance_of(Oystercard)
    end

    it 'should initialize with a balance of zero' do
      expect(oystercard.balance).to eq(0)
    end

    it 'should have an empty journey_log with an empty journeys array' do
      expect(oystercard.journey_log.journeys).to be_empty
    end
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'can top up the balance' do
      expect { oystercard.top_up 1 }.to change { oystercard.balance }.by 1
    end

    it 'has a default maximum balance' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      oystercard.top_up(maximum_balance)
      errormessage = "Maximum balance of #{maximum_balance} exceeded"

      expect { oystercard.top_up 1 }.to raise_error errormessage
    end
  end

  describe '#touch_in' do
    it 'raises an error if balance is low' do
      errormessage = 'Insufficient balance to touch in'
      oystercard.top_up(Journey::MINIMUM_FARE - 1)
      expect { oystercard.touch_in(entry_station) }.to raise_error errormessage
    end

    it 'charges penalty with incomplete journey' do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      expect { oystercard.touch_in(entry_station) }.to change { oystercard.balance }.by(-penalty_fare)
    end
  end

  describe '#touch_out' do
    it 'can touch out' do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      allow(journey_log).to receive(:finish)
      allow(entry_station).to receive(:zone) { 2 }
      allow(exit_station).to receive(:zone) { 4 }
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by(-3)
    end

    it 'can deduct from the balance when touching out' do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      allow(journey_log).to receive(:finish)
      allow(entry_station).to receive(:zone) { 2 }
      allow(exit_station).to receive(:zone) { 2 }
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by(-Journey::MINIMUM_FARE)
    end
  end

  describe '#entry_station' do
    it 'stores the entry station in the current journey' do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      expect(oystercard.journey_log.current_journey.entry_station).to eq(entry_station)
    end
  end

  describe '#exit_station' do
    before(:each) do
      oystercard.top_up(Journey::MINIMUM_FARE + 10)
    end

    it 'touching out ends the current journey' do
      allow(entry_station).to receive(:zone) { 2 }
      allow(exit_station).to receive(:zone) { 4 }
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.journey_log.current_journey).to be nil
    end
  end

  describe '#journeylog' do
    it { is_expected.to respond_to(:journey_log) }

    it 'has an empty list of journeys by default' do
      expect(oystercard.journey_log.journeys).to be_empty
    end

    it 'stores a journey' do
      allow(journey_log).to receive(:journeys) { [] }
      allow(entry_station).to receive(:zone) { 2 }
      allow(exit_station).to receive(:zone) { 4 }
      oystercard.top_up(1)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.journey_log.journeys).not_to be_empty
    end
  end

  describe 'user_stories' do
    it 'should return the updated balance after top-up' do
      oystercard.top_up(20)
      expect(oystercard.balance).to eq(20)
    end

    it 'should deduct the minimum charge when touching out' do
      oystercard.top_up(20)
      allow(journey_log).to receive(:finish)
      allow(entry_station).to receive(:zone) { 2 }
      allow(exit_station).to receive(:zone) { 2 }
      oystercard.touch_in(entry_station)
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by(-min_journey_balance)
    end

    it 'should tell me which station i touched in at' do
      oystercard.top_up(20)
      oystercard.touch_in(entry_station)
      expect(oystercard.journey_log.current_journey.entry_station).to eq(entry_station)
    end

    it 'should list any previous journeys made' do
      oystercard.top_up(20)
      allow(journey_log).to receive(:finish)
      allow(entry_station).to receive(:zone) { 2 }
      allow(exit_station).to receive(:zone) { 2 }
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.journey_log.journeys).not_to be_empty
    end
  end
end
