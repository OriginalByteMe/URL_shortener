# spec/models/user_stat_spec.rb

require 'rails_helper'

RSpec.describe UserStat, type: :model do
  describe 'geocoding' do
    let(:user_stat) { build(:user_stat, origin_city: 'Los Angeles', origin_country: 'USA') }

    before do
      Geocoder.configure(lookup: :test)
      Geocoder::Lookup::Test.set_default_stub(
        [
          {
            'latitude' => 34.052363,
            'longitude' => -118.256551,
            'address' => 'Los Angeles, CA, USA',
            'state' => 'California',
            'state_code' => 'CA',
            'country' => 'United States',
            'country_code' => 'US'
          }
        ]
      )
    end

    it 'geocodes the address on validation' do
      expect(user_stat.latitude).to be_nil
      expect(user_stat.longitude).to be_nil

      user_stat.valid?

      expect(user_stat.latitude).to eq(34.052363)
      expect(user_stat.longitude).to eq(-118.256551)
    end

    it 'assigns the timezone after geocoding' do
      expect(user_stat.timezone).to be_nil

      user_stat.valid?

      expect(user_stat.timezone).to be_present
    end
  end

  describe '#address' do
    it 'returns the city and country' do
      user_stat = build(:user_stat, origin_city: 'Paris', origin_country: 'France')
      expect(user_stat.address).to eq 'Paris, France'
    end

    it 'returns just the country if city is blank' do
      user_stat = build(:user_stat, origin_city: nil, origin_country: 'France')
      expect(user_stat.address).to eq 'France'
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      user_stat = build(:user_stat)
      expect(user_stat).to be_valid
    end

    it 'is invalid without an origin country' do
      user_stat = build(:user_stat, origin_country: nil)
      expect(user_stat).to be_invalid
      expect(user_stat.errors[:origin_country]).to include("can't be blank")
    end
  end
end
