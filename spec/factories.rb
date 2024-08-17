FactoryBot.define do
  factory :shortened_url do
    target_url { "https://www.Google.com" }
    title { "Google" }
    short_url { "abc12345" }
    sanitize_url { "http://google.com" }
  end
end
