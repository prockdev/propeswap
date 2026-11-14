# Needs: gem "rack-attack" in the Gemfile (and a real cache store in production, e.g. Redis/solid_cache).
class Rack::Attack
  # 5 login attempts/minute per IP, and 10 per 5 minutes per phone number.
  throttle("logins/ip", limit: 5, period: 60) do |req|
    req.ip if req.post? && req.path == "/login"
  end

  throttle("logins/phone", limit: 10, period: 300) do |req|
    if req.post? && req.path == "/login"
      req.params["phone"].to_s.gsub(/\D/, "").presence
    end
  end

  self.throttled_responder = lambda do |_req|
    [429, { "Content-Type" => "text/plain", "Retry-After" => "60" },
     ["Too many login attempts. Wait a minute and try again.\n"]]
  end
end
