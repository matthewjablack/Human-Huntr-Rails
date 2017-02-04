class RemoveGameIdFromUser < ActiveRecord::Migration[5.0]
  def change
  	remove_column :users, :game_id
  end
end
