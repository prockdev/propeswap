class AddIndexOnItemRequestsSeenAt < ActiveRecord::Migration[7.1]
  def change
    add_index :item_requests, :seen_at
  end
end
