class GeocodingService
    def self.geocode(address_string)
        result = Geocoder.search(address_string).first
    
        return nil unless result
        {
            street: result.street,
            city: result.city,
            state: result.state,
            zip_code: result.postal_code,
            latitude: result.latitude,
            longitude: result.longitude
        }
    end
end