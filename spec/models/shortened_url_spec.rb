require 'rails_helper'

RSpec.describe ShortenedUrl, type: :model do
  before(:each) do
    if Rails.env.test?
      # Wipe all database records
      # and clear all records so id's are restarted

      ShortenedUrl.delete_all
      ActiveRecord::Base.connection.reset_pk_sequence!(:shortened_urls)
    end
  end

  describe "validations" do
    it "should validate presence of target_url" do
      url = ShortenedUrl.new
      url.short_url = "abc12345"
      expect(url.save).to be false
      expect(url.errors[:target_url]).to include("can't be blank")
    end

    it "should validate the format of target_url" do
      url = ShortenedUrl.new
      url.target_url = "www.google.com"
      expect(url.save).to be false
      expect(url.errors[:target_url]).to include("is invalid")
    end

    it "should have a shortened url of no more than 15 characters" do
      url = ShortenedUrl.new
      url.target_url = "https://www.google.com"
      url.santize
      url.save!
      expect(ShortenedUrl.first.short_url.length).to eq(15)
    end
  end

  describe "sanitize" do
    it "should sanitize the target_url" do
      short_url = ShortenedUrl.new
      short_url.target_url = "https://www.google.com"
      short_url.santize
      expect(short_url.sanitize_url).to eq("http://google.com")
    end
  end

  describe "generate_short_url" do
    it "should generate a unique short_url" do
      url_1 = ShortenedUrl.new
      url_1.target_url = "https://www.google.com"
      url_1.santize
      url_1.save
      url_2 = ShortenedUrl.new
      url_2.target_url = "https://www.google.com"
      url_2.santize
      url_2.save
      expect(url_1.short_url).not_to eq(url_2.short_url)
    end
  end

  describe "retrieve website title on create" do
    it "should retrieve website title on create" do
      short_url = ShortenedUrl.new
      short_url.target_url = "https://www.google.com"
      short_url.santize
      short_url.save
      expect(short_url.title).to eq("Google")
    end

    it "should retrieve website title of website with complex url" do
      first_url = ShortenedUrl.new
      first_url.target_url = "https://www.google.com/search?q=hello+world"
      first_url.santize
      first_url.save
      expect(first_url.title).to eq("Google")

      second_url = ShortenedUrl.new
      second_url.target_url = "https://www.google.random.com/search?q=hello+world"
      second_url.santize
      second_url.save
      expect(second_url.title).to eq("Google")
    end
  end
end
