class Admin::NotificationsController < ApplicationController
  # 通知機能
  def index
    # 自分の通知された情報　未読　かつ　自分の投稿以外
    @notifications = current_admin_user.passive_notifications.where(checked: false)
  end
end
