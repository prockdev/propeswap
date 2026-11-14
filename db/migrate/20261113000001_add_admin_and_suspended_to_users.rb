class AddAdminAndSuspendedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :admin, :boolean, null: false, default: false
    add_column :users, :suspended, :boolean, null: false, default: false
  end
end
