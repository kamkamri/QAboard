# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"

# 絶対パスから相対パス指定　これないとエラーになる
env :PATH, ENV['PATH']
# ログファイルの出力先　バッチ処理の記録が入る
set :output, 'log/cron.log'
# ジョブの実行環境の指定　開発環境、本番環境
set :environment, :development
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

# 日本時間の午前8:00にメール送信される（JSTは+9:00なので-9:00の時間を記述）
# 未読通知があるユーザーにメール通知
# every 1.days, at: '11:00 pm' do
#   runner "ScheduledProcessingMailer.check_notice_mail.deliver_now"
# end

# テスト用
every 1.minutes do
   runner "ScheduledProcessingMailer.check_notice_mail.deliver_now"
end


# Learn more: http://github.com/javan/whenever
