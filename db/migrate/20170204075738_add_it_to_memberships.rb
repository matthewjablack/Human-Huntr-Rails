class AddItToMemberships < ActiveRecord::Migration[5.0]
  def change
    add_column :memberships, :it, :bool
  end
end
