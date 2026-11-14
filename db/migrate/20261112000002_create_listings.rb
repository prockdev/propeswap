class CreateListings < ActiveRecord::Migration[7.1]
  def change
    create_table :listings do |t|
      t.references :user, null: false, foreign_key: true
      t.string   :title, null: false
      t.string   :category, null: false
      t.decimal  :price, precision: 10, scale: 2, null: false
      t.string   :area, null: false
      t.boolean  :sold, null: false, default: false
      t.datetime :posted_at, null: false
      t.timestamps
    end
    add_index :listings, :category
    add_index :listings, :posted_at
  end
end
