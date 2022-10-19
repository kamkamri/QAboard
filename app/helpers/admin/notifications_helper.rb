module Admin::NotificationsHelper
  def admin_unchecked_notifications
    @notifications = current_admin_user.passive_notifications.where(checked: false)
  end
end
