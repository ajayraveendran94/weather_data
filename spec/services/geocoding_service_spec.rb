require 'rails_helper'

RSpec.describe GeocodingService do
    describe '.geocode' do
        context 'with a valid address' do
            it 'returns a hash with address components and coordinates' do
                VCR.use_cassette('geocoding_valid_address') do
                    result = GeocodingService.geocode('10001')
    
                    expect(result).to be_a(Hash)
                    expect(result[:city]).to eq('Cáceres')
                    expect(result[:state]).to eq('Extremadura')
                    expect(result[:zip_code]).to eq('10001')
                    expect(result[:latitude]).to be_a(Float)
                    expect(result[:longitude]).to be_a(Float)
                end
            end
        end

        context 'with an invalid address' do
            it 'returns nil' do
                VCR.use_cassette('geocoding_invalid_address') do
                    result = GeocodingService.geocode('xxxxxx')
                    expect(result).to be_nil
                end
            end
        end
    end
end