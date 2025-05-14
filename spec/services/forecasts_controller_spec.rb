require 'rails_helper'

RSpec.describe ForecastsController, type: :controller do
    describe 'GET #index' do
        it 'returns a successful response' do
            get :index
            expect(response).to be_successful
        end
    end

    describe 'GET #show' do
        context 'with a valid address' do
            let(:forecast_data) do
                {
                    address: { city: 'Cáceres', state: 'Extremadura', zip_code: '10001' },
                    current: { temperature: 75.0 },
                    daily: [],
                    cached: false
                }
            end

            it 'returns a successful response' do
                allow(WeatherService).to receive(:get_forecast).and_return(forecast_data)
    
                get :show, params: { address: '10001' }
    
                expect(response).to be_successful
                expect(assigns(:forecast)).to eq(forecast_data)
            end
        end

        context 'with an invalid address' do
            it 'renders the index template with an error' do
                allow(WeatherService).to receive(:get_forecast).and_return({ error: 'Could not geocode address' })
    
                get :show, params: { address: 'invalid address' }
    
                expect(response).to render_template(:index)
                expect(flash[:alert]).to eq('Could not geocode address')
            end
        end

        context 'without an address' do
            it 'renders the index template with an error' do
                get :show
    
                expect(response).to render_template(:index)
                expect(flash[:alert]).to eq('Please enter an address')
            end
        end
    end
end