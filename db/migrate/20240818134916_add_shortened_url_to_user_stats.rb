class AddShortenedUrlToUserStats < ActiveRecord::Migration[7.2]
  def change
    add_reference :user_stats, :shortened_url, null: false, foreign_key: true, index: true
  end
end
