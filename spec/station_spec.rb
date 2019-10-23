require 'station'

describe Station do
  describe '#defaults' do
    let(:station) { described_class.new('Tottenham Hale', '3') }

    it 'should instantiate the Station class' do
      expect(station).to be_instance_of(Station)
    end

    it 'should have a name' do
      expect(station).to respond_to(:name)
    end

    it 'should have the name it was initialised with' do
      expect(station.name).to eq('Tottenham Hale')
    end

    it 'should have a zone' do
      expect(station).to respond_to(:zone)
    end

    it 'should be in the zone it was initialised with' do
      expect(station.zone).to eq('3')
    end
  end
end
