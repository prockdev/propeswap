class User < ApplicationRecord
  has_secure_password

  has_many :listings, dependent: :destroy
  has_many :item_requests, dependent: :destroy

  enum :role, { buyer: "buyer", seller: "seller" }, validate: true

  before_validation { self.phone = self.class.normalize_phone(phone) }

  validates :name, presence: true, length: { maximum: 60 }
  validates :phone, uniqueness: { message: "already has an account. Log in instead." },
                    format: { with: /\A233\d{9}\z/, message: "must be a valid Ghana number, like 024 123 4567" }
  validates :area, inclusion: { in: Area::NAMES }
  validates :password, length: { minimum: 6 }, allow_nil: true

  # "024 123 4567" -> "233241234567"
  def self.normalize_phone(raw)
    digits = raw.to_s.gsub(/\D/, "")
    digits = "233#{digits[1..]}" if digits.start_with?("0")
    digits
  end

  def display_name
    sample? ? "#{name} (sample)" : name
  end
end
