# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

# Run notify batch job daily at 1:00 AM server time
# Adjust the `environment` option to 'production' when deploying
set :environment, ENV['RAILS_ENV'] || 'production'

every 1.day, at: '1:00 am' do
  runner "NotifyBookmarkBatchJob.perform_now"
end

# If you want to run every hour uncomment below
# every 1.hour do
#   runner "NotifyBookmarkBatchJob.perform_now"
# end
