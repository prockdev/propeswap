# Pick-up areas with coordinates, plus distance between two areas.
class Area
  COORDS = {
    "Legon"  => [5.650, -0.187],
    "Madina" => [5.668, -0.166],
    "Osu"    => [5.556, -0.182],
    "Tema"   => [5.670, -0.017],
    "Kasoa"  => [5.534, -0.416],
    "KNUST"  => [6.673, -1.567]
  }.freeze
  NAMES = COORDS.keys.freeze

  # Haversine distance in km
  def self.km(a, b)
    lat1, lon1 = COORDS.fetch(a).map { |d| d * Math::PI / 180 }
    lat2, lon2 = COORDS.fetch(b).map { |d| d * Math::PI / 180 }
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    h = Math.sin(dlat / 2)**2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dlon / 2)**2
    12_742 * Math.asin(Math.sqrt(h))
  end
end
