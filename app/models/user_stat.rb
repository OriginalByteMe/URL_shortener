class UserStat < ApplicationRecord
  belongs_to :shortened_url
  validates :origin_country, presence: true

  # Auto geocoding, getting lat lang coordinates for showcase on maps
  geocoded_by :address
  after_validation :geocode, if: ->(obj) { obj.address.present? and obj.address_changed? }

  def address
    [ origin_city, origin_country ].compact.join(", ")
  end

  def address_changed?
    origin_city_changed? || origin_country_changed?
  end

  def geocode
    Rails.logger.debug "Geocoding address: #{address}"
    super
  end
end
