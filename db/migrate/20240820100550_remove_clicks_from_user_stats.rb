class RemoveClicksFromUserStats < ActiveRecord::Migration[7.2]
  def change
    remove_column :user_stats, :clicks, :integer
    add_column :user_stats, :region, :string
    add_column :user_stats, :timezone, :string
    add_column :user_stats, :latitude, :float
    add_column :user_stats, :longitude, :float

    add_index :table, [:latitude, :longitude]
  end
end
