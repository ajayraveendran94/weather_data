require 'rails_helper'

RSpec.describe WeatherService do
    let(:address) { create(:address) }

    describe '.get_forecast' do
        context 'when forecast is not cached' do
            it 'fetches forecast from API and caches it' do
                VCR.use_cassette('weather_service_not_cached') do
                    allow(Rails.cache).to receive(:read).and_return(nil)
                    allow(Rails.cache).to receive(:write)
    
                    forecast = WeatherService.get_forecast(address)
    
                    expect(forecast).to be_a(Hash)
                    expect(forecast[:cached]).to eq(false)
                    expect(forecast[:current]).to be_a(Hash)
                    expect(forecast[:daily]).to be_a(Array)
    
                    expect(Rails.cache).to have_received(:write).with(
                        "weather_forecast_#{address.zip_code}",
                        forecast.except(:cached),
                        expires_in: 30.minutes
                    )
                end
        end
        end

        context 'when forecast is cached' do
            it 'returns cached forecast with cache indicator' do
                cached_forecast = {
                    current: { temperature: 75.0 },
                    daily: []
                }

                allow(Rails.cache).to receive(:read).and_return(cached_forecast)

                forecast = WeatherService.get_forecast(address)

                expect(forecast).to be_a(Hash)
                expect(forecast[:cached]).to eq(true)
                expect(forecast[:current]).to eq(cached_forecast[:current])
            end
        end
    end
end