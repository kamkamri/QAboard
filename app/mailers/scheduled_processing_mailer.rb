class ScheduledProcessingMailer < ApplicationMailer

  def check_notice_mail
    @url = "qaboard.xyz"

    # admin_userの未読者
    admin_users_with_unchecked_notices = AdminUser.all.select do |admin_user|
      # 未読通知が1件以上あるadmin_user
      admin_user.passive_notifications.where(admin_visited_id: admin_user.id, checked: false).count >= 1
    end
    # end_userの未読者
    end_users_with_unchecked_notices = EndUser.all.select do |end_user|
      # 未読通知が1件以上あるend_user
      end_user.passive_notifications.where(end_visited_id: end_user.id, checked: false).count >= 1
    end

    # 未読通知があるadmin_userのemail
    admin_users_with_unchecked_notices_mails = admin_users_with_unchecked_notices.pluck(:email)
    # 未読通知があるend_userのemail
    end_users_with_unchecked_notices_mails = end_users_with_unchecked_notices.pluck(:email)

    # admin_userと、end_userのemailを合体
    users_with_unckecked_notices_mails = admin_users_with_unchecked_notices_mails + end_users_with_unchecked_notices_mails

    mail(subject:"未読の通知があります", bcc: users_with_unckecked_notices_mails)

  end

end
