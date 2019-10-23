require 'journey'

describe Journey do
  subject(:journey) { described_class.new }
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }

  context '#initialize' do
    it 'should be an instance of the journey class' do
      expect(journey).to be_instance_of(Journey)
    end

    it 'with empty entry station' do
      expect(journey.entry_station).to eq nil
    end
    it 'with empty exit station' do
      expect(journey.exit_station).to eq nil
    end
  end

  context '#start' do
    it 'stores given station into entry_station' do
      journey.start(entry_station)
      expect(journey.entry_station).to eq entry_station
    end
  end

  context '#finish' do
    it 'stores given station into exit_station' do
      journey.finish(exit_station)
      expect(journey.exit_station).to eq exit_station
    end
  end

  context '#complete?' do
    it 'checks whether journey is complete' do
      journey.start(entry_station)
      journey.finish(exit_station)
      expect(journey).to be_complete
    end
  end

  context '#fare' do
    it 'charges minimum fare when journey is complete' do
      journey.start(entry_station)
      journey.finish(exit_station)
      expect(journey.fare).to eq described_class::MINIMUM_FARE
    end

    it 'charges penalty when journey is incomplete' do
      journey.start(entry_station)
      expect(journey.fare).to eq described_class::PENALTY_FARE
    end
  end
end
