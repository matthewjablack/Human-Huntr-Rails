class AddAdminToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :admin, :bool, default: false
  end
end
