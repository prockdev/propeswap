class AddSeenAtToItemRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :item_requests, :seen_at, :datetime
  end
end
