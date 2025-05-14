class Address < ApplicationRecord
    #validates :street, :city, :state, :zip_code, presence: true
    geocoded_by :full_address
    after_validation :geocode, if: ->(object) { object.full_address.present? && (object.latitude.blank? || object.longitude.blank?) }
    
    def full_address
        [street, city, state, zip_code].compact.join(', ')
    end
end
