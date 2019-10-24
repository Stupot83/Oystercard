require 'journey'

describe Journey do
  subject(:journey) { described_class.new }
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:entry_zone) { 6 }
  let(:exit_zone) { 3 }

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
    context 'work out the fare' do
      before do
        journey.start(entry_station)
        journey.finish(exit_station)
        allow(entry_station).to receive(:zone) { entry_zone }
        allow(exit_station).to receive(:zone) { exit_zone }
        expect(journey.fare).to eq(Journey::MINIMUM_FARE + (entry_zone - exit_zone).abs)
      end

      it 'within the same zone' do
        allow(entry_station).to receive(:zone) { 3 }
        allow(exit_station).to receive(:zone) { 3 }
        expect(journey.fare).to eq Journey::MINIMUM_FARE
      end

      it 'returns the fare of £1 when within same zone' do
        allow(entry_station).to receive(:zone) { 2 }
        allow(exit_station).to receive(:zone) { 2 }
        expect(journey.fare).to eq 1
      end

      it 'returns the fare of £2 when travelled 1 zone' do
        allow(entry_station).to receive(:zone) { 2 }
        allow(exit_station).to receive(:zone) { 3 }
        expect(journey.fare).to eq 2
      end

      it 'returns the fare of £3 when travelled 2 zones' do
        allow(entry_station).to receive(:zone) { 2 }
        allow(exit_station).to receive(:zone) { 4 }
        expect(journey.fare).to eq 3
      end

      it 'returns the fare of £4 when travelled 3 zones' do
        allow(entry_station).to receive(:zone) { 2 }
        allow(exit_station).to receive(:zone) { 5 }
        expect(journey.fare).to eq 4
      end

      it 'returns the fare of £5 when travelled 4 zones' do
        allow(entry_station).to receive(:zone) { 6 }
        allow(exit_station).to receive(:zone) { 2 }
        expect(journey.fare).to eq 5
      end
    end

    it 'returns penalty when not touched out' do
      journey.start(entry_station)
      expect(journey.fare).to eq Journey::PENALTY_FARE
    end

    it 'returns penalty when not touched in' do
      journey.finish(exit_station)
      expect(journey.fare).to eq Journey::PENALTY_FARE
    end
  end
end
