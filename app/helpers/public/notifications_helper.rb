module Public::NotificationsHelper
  def end_unchecked_notifications
    @notifications = current_end_user.passive_notifications.where(checked: false)
  end
end
