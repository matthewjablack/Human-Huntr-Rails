class AddDetailsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :game_id, :integer
    add_column :users, :longitude, :float
    add_column :users, :latitude, :float
  end
end
