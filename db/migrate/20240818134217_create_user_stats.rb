class CreateUserStats < ActiveRecord::Migration[7.2]
  def change
    create_table :user_stats do |t|
      t.string :origin_city
      t.string :origin_country
      t.integer :clicks

      t.timestamps
    end
  end
end
