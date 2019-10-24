require 'journey_log'

describe JourneyLog do
  let(:journey_class) { Journey }
  let(:oystercard) { double :oystercard }
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  subject(:journey_log) { JourneyLog.new(journey_class, oystercard) }

  before(:each) do
    allow(oystercard).to receive(:deduct)
    allow(entry_station).to receive(:zone) { 2 }
    allow(exit_station).to receive(:zone) { 2 }
  end

  context '#initialize' do
    it 'should be an instance of the JourneyLog class' do
      expect(journey_log).to be_instance_of(JourneyLog)
    end

    it 'has a journey_class' do
      expect(journey_log.journey_class).to eq journey_class
    end

    it 'has an empty journeys array' do
      expect(journey_log.journeys).to be_empty
    end

    it 'initializes with empty current journey' do
      expect(journey_log.current_journey).to be_nil
    end
  end

  describe '#start' do
    it 'creates a new current journey' do
      journey_log.start(entry_station)
      expect(journey_log.current_journey).to be_instance_of(Journey)
    end

    context 'with incomplete journey' do
      it 'raises no error' do
        expect { journey_log.start(entry_station) }.not_to raise_error
      end
    end
  end

  describe '#finish' do
    it 'increases journeys count by 1' do
      expect { journey_log.finish(exit_station) }.to change { journey_log.journeys.count }.by 1
    end

    it 'stores a journey in journeys' do
      journey_log.finish(exit_station)
      expect(journey_log.journeys[-1]).to be_instance_of(Journey)
    end

    context 'with no current journey' do
      it 'raises no error' do
        expect { journey_log.finish(exit_station) }.not_to raise_error
      end
    end

    it 'deducts fare from balance' do
      journey_log.start(entry_station)
      allow(entry_station).to receive(:zone).and_return(2)
      allow(exit_station).to receive(:zone).and_return(3)
      expect { journey_log.finish(exit_station) }.not_to raise_error
    end
  end
end
