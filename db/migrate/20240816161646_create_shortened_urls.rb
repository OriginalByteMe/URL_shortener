class CreateShortenedUrls < ActiveRecord::Migration[7.2]
  def change
    create_table :shortened_urls do |t|
      t.text :target_url
      t.string :short_url
      t.string :sanitize_url
      t.string :title

      t.timestamps
    end
  end
end
