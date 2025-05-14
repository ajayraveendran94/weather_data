class WeatherService
    include HTTParty
    base_uri '  5'
    
    def self.current_weather(latitude, longitude)
        response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather", {
            query: {
                lat: latitude,
                lon: longitude,
                appid: ENV['OPENWEATHER_API_KEY']
            }
        })
        if response.success?
            response.parsed_response
        else 
            { error: "API Error: #{response.code}"}
        end
        #fetch_weather("/weather", latitude, longitude)
    end
    
    def self.extended_forecast(latitude, longitude)
        fetch_weather("/forecast", latitude, longitude)
    end
    

    def self.get_forecast(address_or_zip)
        zip_code = extract_zip_code(address_or_zip)
        cache_key = "weather_forecast_#{zip_code}"
        cached_forecast = Rails.cache.read(cache_key)
        return cached_forecast.merge(cached: true) if cached_forecast
        address_data =  if address_or_zip.is_a? (Address)
                            address_or_zip
                        else
                            geocoded = GeocodingService.geocode(address_or_zip)
                            Address.find_or_create_by(geocoded) if geocoded
                        end
        return {  error: "Could not geocode address" }  unless address_data
    
        current = current_weather(address_data.latitude, address_data.longitude)
        #extended = extended_forecast(address_data.latitude, address_data.longitude)
    
        forecast = process_forecast_data(current, address_data) #extended removed
        Rails.cache.write(cache_key, forecast, expires_in: 30. minutes)
        forecast.merge(cached: false)
    end
    
    private
    
    def self.fetch_weather(endpoint, latitude, longitude)
        options = {
            query: {
                lat: latitude,
                lon: longitude,
                appid: ENV['OPENWEATHER_API_KEY'],
                units: 'imperial'
                # Use Fahrenheit
            }
        }
    
        response = get(endpoint, options)
    
        if response.success?
            response.parsed_response
        else 
            { error: "API Error: #{response.code}"}
        end
    end
    
    def self.extract_zip_code(address_or_zip)
        if address_or_zip.is_a? (Address)
            address_or_zip.zip_code
        elsif address_or_zip.match(/\d{5}(-\d{4})?/)
            address_or_zip.match(/\d{5}(-\d{4})?/)[0]
        else
            geocoded = GeocodingService.geocode(address_or_zip)
            geocoded[:zip_code] if geocoded
        end
    end
    
    def self.process_forecast_data(current, address) #extended removed
        return { error: current[:error] } if current[:error]
        #return { error: extended[:error] } if extended[:error]
        
        #daily_forecasts = process_daily_forecasts(extended)
        {
        address: {
            street: address.street,
            city: address.city,
            state: address.state,
            zip_code: address.zip_code
        },
        current: {
            temperature: current.dig('main', 'temp'),
            feels_like: current.dig('main', 'feels_like'),
            min: current.dig('main', 'temp_min'),
            max: current.dig('main', 'temp_max'),
            humidity: current.dig('main', 'humidity'),
            weather: current.dig('weather', 0, 'main'),
            description: current.dig('weather', 0, 'description'),
            icon: current.dig('weather', 0, 'icon'),
            wind_speed: current.dig('wind', 'speed'),
            datetime: Time.at(current['dt'])
        },
        #daily: daily_forecasts,
        timestamp: Time.now
        }
    end
    
    # def self.process_daily_forecasts(extended)
    #     forecasts_by_day = extended['list'].group_by do | forecast |
    #         Time.at(forecast['dt']).to_date
    #     end

    #     forecasts_by_day.map do | date, forecasts |
    #         temps = forecasts.map { | f | f.dig('main', 'temp')}
    
    #         {
    #             date: date,
    #             min: temps.min,
    #             max: temps.max,
    #             forecasts: forecasts.map do | f | {
    #                 temperature: f.dig('main', 'temp'),
    #                 feels_like: f.dig('main', 'feels_like'),
    #                 weather: f.dig('weather', 0, 'main'),
    #                 description: f.dig('weather', 0, 'description'),
    #                 icon: f.dig('weather', 0, 'icon'),
    #                 time: Time.at(f['dt']),
    #                 wind_speed: f.dig('wind', 'speed')
    #             }
    #             end
    #         }
    #     end
    # end
end