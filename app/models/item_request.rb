class ItemRequest < ApplicationRecord
  SPOTS = ["Busy fuel station", "Campus main gate", "Mall entrance", "Police station front"].freeze

  belongs_to :user
  belongs_to :listing

  enum :status, { waiting: "waiting", moved: "moved", done: "done" }

  validates :spot, inclusion: { in: SPOTS }
  validates :listing_id, uniqueness: { scope: :user_id, conditions: -> { where.not(status: "done") },
                                       message: "You already requested this item." }

  scope :active, -> { where.not(status: "done") }

  # Moves this request to the nearest other live seller in the same category.
  # Returns the new listing, or nil if nobody else is available.
  def move_to_next!
    already_open = user.item_requests.active.select(:listing_id)
    candidate = Listing.live.includes(:user)
                       .where(category: listing.category)
                       .where.not(id: tried_ids)
                       .where.not(id: already_open)
                       .where.not(user_id: user_id)
                       .min_by { |l| l.distance_from(user.area) }
    return nil unless candidate

    update!(listing: candidate, tried_ids: tried_ids + [candidate.id], status: :moved)
    candidate
  end
end
