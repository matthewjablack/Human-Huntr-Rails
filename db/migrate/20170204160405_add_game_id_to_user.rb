class AddGameIdToUser < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :game_id, :integer, default: 0
  end
end
