class Public::NotificationsController < ApplicationController
  # 通知機能
  def index
    # 自分の通知された情報　未読　かつ　自分の投稿以外
    @notifications = current_end_user.passive_notifications.where(checked: false)
    @jobs = Job.where(is_deleted: false)
  end
end
