class CreateItemRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :item_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :listing, null: false, foreign_key: true
      t.string :status, null: false, default: "waiting"
      t.string :spot, null: false
      t.bigint :tried_ids, array: true, null: false, default: []
      t.timestamps
    end
    # A buyer can have only one open request per listing
    add_index :item_requests, %i[user_id listing_id], unique: true,
              where: "status <> 'done'", name: "index_item_requests_one_open_per_listing"
  end
end
