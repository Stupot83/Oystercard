require 'oystercard'
require 'station'

describe Oystercard do
  let(:oystercard) { Oystercard.new }
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:journey) { { entry_station: entry_station, exit_station: exit_station } }
  let(:station) { Station.new('Tottenham Hale', 'Zone 3') }

  describe 'defaults' do
    it 'should instantiate the Oystercard class' do
      expect(oystercard).to be_instance_of(Oystercard)
    end

    it 'should initialize with a balance of zero' do
      expect(oystercard.balance).to eq(0)
    end

    it 'should have an empty journeys array' do
      expect(oystercard.journeys).to be_empty
    end
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'can top up the balance' do
      expect { oystercard.top_up 1 }.to change { oystercard.balance }.by 1
    end

    it 'has a default maximum balance of £90' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      oystercard.top_up(maximum_balance)
      errormessage = "Maximum balance of #{maximum_balance} exceeded"

      expect { oystercard.top_up 1 }.to raise_error errormessage
    end
  end

  describe '#touch_in' do
    it 'can touch in' do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station)
      expect(oystercard).to be_in_journey
    end

    it 'Raises an error if balance is low' do
      errormessage = 'Insufficient balance to touch in'
      expect { oystercard.touch_in(entry_station) }.to raise_error errormessage
    end
  end

  describe '#touch_out' do
    it 'can touch out' do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard).not_to be_in_journey
    end

    it 'can deduct from the balance when touching out' do
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by(-Oystercard::MINIMUM_CHARGE)
    end

    it 'should set the entry station to nil' do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.entry_station).to eq nil
    end
  end

  describe '#entry_station' do
    it 'stores the entry station' do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station)
      expect(oystercard.entry_station).to eq entry_station
    end
  end

  describe '#exit_station' do
    it 'stores exit station' do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.exit_station).to eq exit_station
    end
  end

  describe '#journeys' do
    it { is_expected.to respond_to(:journeys) }

    it 'has an empty list of journeys by default' do
      expect(oystercard.journeys).to be_empty
    end

    it 'stores a journey' do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.journeys).to include journey
    end
  end

  describe 'user_stories' do
    it 'should return the updated balance after top-up' do
      oystercard.top_up(20)
      expect(oystercard.balance).to eq(20)
    end

    it 'should update a card as in use when touching in' do
      oystercard.top_up(20)
      oystercard.touch_in('Tottenham Hale')
      expect(oystercard.in_journey?).to eq(true)
    end

    it "should update a card as 'not in use' when touching in" do
      oystercard.top_up(20)
      oystercard.touch_in('Tottenham Hale')
      oystercard.touch_out('London Kings Cross')
      expect(oystercard.in_journey?).to eq(false)
    end

    it 'should deduct the minimum charge when touching out' do
      oystercard.top_up(20)
      oystercard.touch_in('Tottenham Hale')
      expect { oystercard.touch_out('London Kings Cross') }.to change { oystercard.balance }.by(-5)
    end

    it 'should tell me which station i touched in at' do
      oystercard.top_up(20)
      oystercard.touch_in('Tottenham Hale')
      expect(oystercard.entry_station).to eq('Tottenham Hale')
    end

    it 'should list any previous journeys made' do
      oystercard.top_up(20)
      oystercard.touch_in('Tottenham Hale')
      oystercard.touch_out('London Kings Cross')
      expect(oystercard.journeys).to eq [{ entry_station: 'Tottenham Hale', exit_station: 'London Kings Cross' }]
    end

    it 'should know which zone a station is in' do
      expect(station.zone).to eq 'Zone 3'
      expect(station.name).to eq 'Tottenham Hale'
    end
  end
end
