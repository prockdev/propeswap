class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string  :name, null: false
      t.string  :phone, null: false
      t.string  :password_digest, null: false
      t.string  :area, null: false
      t.string  :role, null: false, default: "buyer"
      t.boolean :auto_move, null: false, default: true
      t.boolean :sample, null: false, default: false
      t.timestamps
    end
    add_index :users, :phone, unique: true
  end
end
