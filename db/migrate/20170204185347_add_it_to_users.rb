class AddItToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :it, :bool, default: false
  end
end
