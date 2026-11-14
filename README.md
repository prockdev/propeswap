# PropeSwap

A local marketplace for used items. Instead of scrolling through listings and messaging sellers who may never reply, buyers request what they need. If a seller doesn't respond, the request moves to the next nearest seller.

Built by PropeLabs. Status: early MVP.

## Features

**For buyers**
- Browse and search live listings by category or keyword, sorted by distance from your area
- Send a request on an item and pick a safe meeting spot
- If a seller doesn't reply, move the request to the next nearest seller of the same category

**For sellers**
- Post items with a title, category, price and area
- Listings expire after 7 days, and can be renewed or marked as sold
- A requests inbox with an unseen-requests badge

**Safety**
- Preset public meeting spots instead of private addresses
- Login rate limiting
- Admins can suspend accounts and remove listings, and every admin action is logged

**For admins**
- Overview counts, user search with suspend and restore, listing search with remove, and an audit log

## Tech stack

Ruby on Rails (server-rendered ERB, no JavaScript build step), PostgreSQL, bcrypt for passwords, rack-attack for rate limiting.

## Getting started

This repository holds the application files. You add them to a fresh Rails app.

**You need:** Ruby 3.1 or newer, Rails 7.1, and PostgreSQL running locally.

```bash
rails new propeswap -d postgresql --skip-javascript
cd propeswap
```

1. In the `Gemfile`, uncomment `gem "bcrypt"` and add `gem "rack-attack"`, then run `bundle install`.
2. Copy the contents of this repository into the project, replacing `config/routes.rb`, `app/controllers/application_controller.rb` and any other files it asks about.
3. Set up the database:
   ```bash
   bin/rails db:create db:migrate db:seed
   ```
4. Start the server and open http://localhost:3000:
   ```bash
   bin/rails server
   ```

The seed data creates a few sample sellers and listings so there is something to browse. Sign up as a buyer or a seller to try both sides.

### Admin access

Create an account through the signup page, then promote it:

```bash
bin/rails admin:grant PHONE=0241234567
```

The admin area is at `/admin`. Use `bin/rails admin:revoke PHONE=...` to remove access. The admin flag cannot be set through the signup form.

## How a request works

1. A buyer requests an item and chooses a meeting spot.
2. If the seller does not respond, the buyer taps "No reply yet".
3. The request moves to the nearest other live seller of the same category, skipping sellers already tried.

## Project structure

| Path | What it holds |
|---|---|
| `app/models` | `User`, `Listing`, `ItemRequest`, `Area` (distances), `AdminAction` (audit log) |
| `app/controllers` | Buyer and seller pages, requests, signup and login, and the `admin/` area |
| `app/views` | Server-rendered ERB templates |
| `config/initializers/rack_attack.rb` | Login throttling |
| `db/migrate`, `db/seeds.rb` | Schema and sample data |
| `lib/tasks/admin.rake` | The `admin:grant` and `admin:revoke` tasks |

## Known limitations

- "No reply yet" is a manual button. A timed background job is the natural next step.
- Distances use a fixed list of areas, not a geocoding service.
- In production, rate limiting needs a shared cache store such as Redis.
- Payments and escrow are not included.

## Contributing

Issues and pull requests are welcome. For larger changes, open an issue first to discuss what you would like to change.
