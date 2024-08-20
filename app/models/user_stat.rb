class UserStat < ApplicationRecord
  # Auto geocoding, getting lat lang coordinates for showcase on maps
  geocoded_by :address
  after_validation :geocode, :assign_timezone
  def address
    [ origin_city, origin_country ].compact.join(", ")
  end

  def assign_timezone
    self.timezone = Timezone.lookup(latitude, longitude)
  end
end
