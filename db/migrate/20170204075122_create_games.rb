class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :user_id
      t.float :longitude
      t.float :latitude
      t.float :radius

      t.timestamps
    end
  end
end
