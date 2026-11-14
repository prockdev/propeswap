class Listing < ApplicationRecord
  CATEGORIES = %w[Phones Laptops Furniture Appliances Books Fashion Other].freeze
  EXPIRY = 7.days

  CATEGORY_EMOJI = {
    "Phones" => "📱", "Laptops" => "💻", "Furniture" => "🪑", "Appliances" => "🔌",
    "Books" => "📚", "Fashion" => "👕", "Other" => "📦"
  }.freeze
  KEYWORD_EMOJI = {
    "fridge" => "🧊", "freezer" => "🧊", "tv" => "📺", "television" => "📺", "fan" => "🌀",
    "bed" => "🛏️", "mattress" => "🛏️", "desk" => "🪑", "chair" => "🪑", "iphone" => "📱",
    "samsung" => "📱", "laptop" => "💻", "macbook" => "💻", "book" => "📚", "shoe" => "👟",
    "sneaker" => "👟", "jacket" => "🧥", "dress" => "👗", "speaker" => "🔊", "headphone" => "🎧",
    "bike" => "🚲", "bicycle" => "🚲", "microwave" => "🍲", "blender" => "🥤", "cooker" => "🍳",
    "gas" => "🔥", "watch" => "⌚", "bag" => "🎒"
  }.freeze

  belongs_to :user
  has_many :item_requests, dependent: :destroy

  before_validation { self.posted_at ||= Time.current }

  validates :title, presence: true, length: { maximum: 100 }
  validates :category, inclusion: { in: CATEGORIES }
  validates :area, inclusion: { in: Area::NAMES }
  validates :price, numericality: { greater_than: 0, less_than: 10_000_000 }

  scope :live, -> { joins(:user).where(users: { suspended: false }).where(sold: false).where("listings.posted_at > ?", EXPIRY.ago) }
  scope :in_category, ->(c) { c.present? ? where(category: c) : all }
  scope :search, ->(q) { q.present? ? where("listings.title ILIKE ?", "%#{Listing.sanitize_sql_like(q.to_s)}%") : all }

  def expired?
    !sold? && posted_at.present? && posted_at + EXPIRY <= Time.current
  end

  def days_left
    [((posted_at + EXPIRY - Time.current) / 86_400.0).ceil, 0].max
  end

  def distance_from(area_name)
    Area.km(area_name, area)
  end

  def emoji
    t = title.to_s.downcase
    KEYWORD_EMOJI.find { |word, _| t.include?(word) }&.last || CATEGORY_EMOJI.fetch(category, "📦")
  end
end
