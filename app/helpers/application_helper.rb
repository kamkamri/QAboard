module ApplicationHelper
  # admin 未読のツリー確認(レスポンス含め)
  def h_appli_admin_unchecked_notifications_tree(tree_id)
    current_admin_user.passive_notifications.where(tree_id: tree_id, checked: false)
  end
  
  # end 未読のツリーがあるか確認(レスポンス含め)
  def h_appli_end_unchecked_notifications_tree(tree_id)
    current_end_user.passive_notifications.where(tree_id: tree_id, checked: false)
  end
  
end
