# PropeSwap on Rails (ERB, server-rendered)

This folder holds only the app-specific files (including the admin area). Generate a fresh Rails app, then copy these over it.

## Setup
1. Have PostgreSQL running locally.
2. Generate the app (no JavaScript tooling needed, the pages work with plain forms):
   `rails new propeswap -d postgresql --skip-javascript`
3. `cd propeswap`, open `Gemfile`, uncomment `gem "bcrypt"`, add `gem "rack-attack"` (login rate limiting), then `bundle install`.
4. Copy everything from this folder into the project, overwriting
   `config/routes.rb` and `app/controllers/application_controller.rb`.
5. `bin/rails db:create db:migrate db:seed`
6. Make yourself an admin: `bin/rails admin:grant PHONE=0241234567` (use your own number; `admin:revoke` removes it).
7. `bin/rails server` and open http://localhost:3000 (admin area at `/admin`).

## Layout
- `app/models`: `User`, `Listing`, `ItemRequest`, `Area` (distances)
- `app/controllers`: sessions, users (signup), listings (buyer + seller pages), item_requests, incoming_requests (seller inbox), items (listing detail), `admin/` (dashboard, users, listings, audit log)
- `app/models/admin_action.rb`: audit log of admin actions (suspend, restore, remove listing)
- `config/initializers/rack_attack.rb`: login throttling (needs a shared cache store such as Redis in production)
- `app/views`: ERB templates (buyer page, seller page, login, signup)
- `app/assets/stylesheets/propeswap.css`: your original styling
- `db/migrate`, `db/seeds.rb`

## Admin area
- Overview counts, user search with suspend/restore, listing search with remove, and an audit log of every admin action.
- Suspended users are signed out and cannot log in; their listings are hidden from the public feed and cannot be requested.
- Only admins can open `/admin`. The `admin` flag cannot be set through signup.

## Differences from the HTML prototype
- Passwords use bcrypt (server side). Accounts and listings live in Postgres.
- "Request" is `ItemRequest` (a plain `Request` class would clash with Rails internals).
- "No reply yet" is still a manual button; a timed background job is the next step.
- 
