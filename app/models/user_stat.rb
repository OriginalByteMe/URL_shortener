class UserStat < ApplicationRecord
  validates :origin_country, presence: true
  # Auto geocoding, getting lat lang coordinates for showcase on maps
  geocoded_by :address
  after_validation :geocode
  def address
    [ origin_city, origin_country ].compact.join(", ")
  end
end
