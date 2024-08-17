class ShortenedUrl < ApplicationRecord
  UNIQUE_URI_LENGTH = 15
  validates :target_url, presence: true, on: :create
  validates_format_of :target_url, with: URI.regexp, on: :create
  before_create :generate_short_url
  before_create :santize
  before_create :retrieve_title

  # Generates a unique short URL for the current ShortenedUrl instance.
  #
  # This method uses SecureRandom to generate a random alphanumeric string of
  # length UNIQUE_URI_LENGTH. It checks the database for an existing ShortenedUrl
  # with the same short URL and recursively calls itself if a duplicate is found.
  #
  # Parameters: None
  #
  # Returns: None
  def generate_short_url
    url = SecureRandom.alphanumeric(UNIQUE_URI_LENGTH)
    possible_duplicate_url = ShortenedUrl.where(short_url: url).any?
    # Small check to prevent generating a duplicate short URL
    # Possible bug if same url is entered multiple times (more times than I could count), unique url is not possible then, will be infinte loop
    if possible_duplicate_url
      self.generate_short_url
    else
      self.short_url = url
    end
  end

  # Finds a duplicate of the current ShortenedUrl instance.
  #
  # This method uses the `find_by_sanitize_url` method to find a ShortenedUrl
  # instance with the same sanitized URL as the current instance.
  #
  # @return [ShortenedUrl, nil] The found duplicate ShortenedUrl instance, or nil
  #   if no duplicate is found.
  def find_duplicate
    ShortenedUrl.find_by_sanitize_url(self.sanitize_url)
  end

  # Checks if the current ShortenedUrl instance has a new URL.
  #
  # Parameters: None
  #
  # Returns: True if the URL is new, False otherwise.
  def new_url?
    find_duplicate.nil?
  end

  # Sanitizes the target URL by removing unnecessary protocol and subdomain information.
  #
  # This method modifies the target_url attribute by stripping leading/trailing whitespace,
  # converting to lowercase, and removing 'http://' or 'www.' prefixes.
  #
  # Parameters: None
  #
  # Returns: None
  def santize
    self.target_url.strip!
    self.sanitize_url = self.target_url.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
    self.sanitize_url = "http://#{self.sanitize_url}"
  end

  def retrieve_title
    match = self.sanitize_url.match(/^https?:\/\/([^.]+)\./)
    if match
      self.title = match[1].capitalize
    end
  end
end
