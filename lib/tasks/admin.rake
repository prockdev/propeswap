namespace :admin do
  desc "Make a user an admin: bin/rails admin:grant PHONE=0241234567"
  task grant: :environment do
    user = User.find_by(phone: User.normalize_phone(ENV["PHONE"])) or abort "No user with that phone number."
    user.update!(admin: true)
    puts "#{user.name} is now an admin."
  end

  desc "Remove admin access: bin/rails admin:revoke PHONE=0241234567"
  task revoke: :environment do
    user = User.find_by(phone: User.normalize_phone(ENV["PHONE"])) or abort "No user with that phone number."
    user.update!(admin: false)
    puts "#{user.name} is no longer an admin."
  end
end
