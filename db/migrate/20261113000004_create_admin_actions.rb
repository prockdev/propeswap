class CreateAdminActions < ActiveRecord::Migration[7.1]
  def change
    create_table :admin_actions do |t|
      t.references :admin, foreign_key: { to_table: :users, on_delete: :nullify }
      t.string :action, null: false
      t.string :target_type
      t.bigint :target_id
      t.text :note
      t.timestamps
    end
    add_index :admin_actions, :created_at
  end
end
