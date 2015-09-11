# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, "/home/deploy/challfie/shared/log/cron_log.log"

every 1.day, :at => '3:30am' do
	runner "DailyChallenge.new.set_daily_challenge"
end

every :hour, :at: 10 do
	daily = DailyChallenge.last
	#runner "Delayed::Job.enqueue(DailyChallenge.new.send_daily_challenge_notifications, priority:1, run_at:Time.now)"
	runner "daily.delay.send_daily_challenge_notifications"
end