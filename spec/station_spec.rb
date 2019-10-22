require 'station'

describe Station do
  describe '#defaults' do
    let(:station) { Station.new('Tottenham Hale', 'Zone 3') }

    it 'should instantiate the Station class' do
      expect(station).to be_instance_of(Station)
    end

    it 'should have a name' do
      expect(station).to respond_to(:name)
    end

    it 'should have a zone' do
      expect(station).to respond_to(:zone)
    end
  end
end
