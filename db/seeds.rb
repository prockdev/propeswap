# Sample sellers so the buyer page isn't empty (they can't log in and have no WhatsApp).
SAMPLES = [
  { name: "Kofi", area: "Legon",  title: "Mini fridge",             category: "Appliances", price: 350,  days_ago: 1 },
  { name: "Ama",  area: "Madina", title: "Mini fridge",             category: "Appliances", price: 320,  days_ago: 2 },
  { name: "Yaw",  area: "Osu",    title: "iPhone 11, good battery", category: "Phones",     price: 1450, days_ago: 1 },
  { name: "Esi",  area: "Legon",  title: "Study desk",              category: "Furniture",  price: 180,  days_ago: 3 }
].freeze

SAMPLES.each_with_index do |s, i|
  user = User.find_or_create_by!(phone: "23320000000#{i + 1}") do |u|
    u.assign_attributes(name: s[:name], area: s[:area], role: "seller", sample: true,
                        password: SecureRandom.hex(12))
  end
  Listing.find_or_create_by!(user: user, title: s[:title]) do |l|
    l.assign_attributes(category: s[:category], price: s[:price], area: s[:area],
                        posted_at: s[:days_ago].days.ago)
  end
end
