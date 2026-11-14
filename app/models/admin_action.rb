# Who did what in the admin area.
class AdminAction < ApplicationRecord
  belongs_to :admin, class_name: "User", optional: true

  def self.record!(admin, action, target, note = nil)
    create!(admin: admin, action: action, target_type: target.class.name, target_id: target.id, note: note)
  end
end
