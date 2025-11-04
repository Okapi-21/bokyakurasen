# frozen_string_literal: true

# Production-safe runner to execute all scripts under script/ in a controlled order.
# Usage:
#   RAILS_ENV=production bundle exec rails runner script/production_run_seeds.rb
#
# Requirements / Safety:
# - Must set ADMIN_EMAIL env var to an existing admin user email in production.
# - This script will NOT create users in production.
# - Always backup DB before running.

ADMIN_ID    = ENV['ADMIN_ID']&.presence
ADMIN_EMAIL = ENV['ADMIN_EMAIL']&.presence

if ADMIN_ID
  admin = User.find_by(id: ADMIN_ID.to_i)
  raise "Admin user not found with id=#{ADMIN_ID}" unless admin
else
  raise "Set ADMIN_ID or ADMIN_EMAIL in env before running seeds in production" unless ADMIN_EMAIL
  admin = User.find_by(email: ADMIN_EMAIL)
  raise "Admin user not found: #{ADMIN_EMAIL}" unless admin
end

puts "Running production seeds as: #{admin.email} (id=#{admin.id})"

# Define ordered list of scripts to run. Adjust order if needed.
SCRIPTS = [
  'script/seed_categories.rb',
  'script/seed_more_challenges.rb',
  'script/seed_custom_explanations.rb',
  'script/fill_more_explanations.rb'
]

SCRIPTS.each do |script_path|
  unless File.exist?(script_path)
    puts "Skip missing script: #{script_path}"
    next
  end

  puts "--- Running #{script_path} ---"
  begin
    # load the script in the context where `user` is the admin for safety
    user = admin
    load script_path
    puts "--- Finished #{script_path} ---"
  rescue => e
    puts "Error while running #{script_path}: #{e.class} #{e.message}"
    puts e.backtrace.join("\n")
    puts "Aborting further scripts." 
    exit 1
  end
end

puts "All scripts finished."
