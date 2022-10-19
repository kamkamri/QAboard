class Tree < ApplicationRecord

  # アソシエーション
  #  optional:true  は、belongs_to の外部キーのnilを許可する
  belongs_to :admin_user, optional: true
  belongs_to :end_user, optional: true
  has_many :responses, dependent: :destroy
  belongs_to :area
  # Treeの中のpost_idも、areaとのアソシエーションがあるので、名前をpostと名づける
  belongs_to :post, class_name: "Area"
  belongs_to :job

  # 添付ファイル
  has_many_attached :attachments


  # モデルファイルに並び替えを行う
  default_scope -> {order(updated_at: :desc) }

  # 最新レスポンスを1件取得
  has_one :latest_response, -> { order(updated_at: :desc)}, class_name: :Response

  # 通知機能
  has_many :notifications, dependent: :destroy


  # バリデーション
  validates :area_id, presence: true
  validates :post_id, presence: true
  validates :job_id, presence: true
  validates :title, presence: true
  validates :body, presence: true





  # 1　admin投稿ツリーの通知機能
  # 1_①admin通知機能
  def create_admin_ad_notification_tree!(current_user, tree_id, post_id, job_id)
      # ◆◆admin_userが投稿したツリー
      # adminuser 担当拠点かつ担当業務に関連するアドミンユーザー
      admin_ids = AdminUser.eager_load(:your_areas, :your_jobs).where(your_areas: {area_id: post_id}).where(your_jobs: {job_id: job_id}).where(is_deleted: false).distinct.ids
      # 重複を削除
      admin_ids = admin_ids.uniq
      # nilを削除
      admin_ids = admin_ids.compact
      # 通知を送られるadmin_userを、一つずつ取り出し、通知を作成する
      admin_ids.each do |admin_id|
        # ②通知機能保存に飛ぶ
        save_admin_ad_notification_tree!(current_user, tree_id, post_id, job_id, admin_id)
      end
  end

  # 1_②通知機能保存
  def save_admin_ad_notification_tree!(current_user, tree_id, post_id, job_id, admin_visited_id)
    notification = current_user.active_notifications.new(
      tree_id: id,
      admin_visited_id: admin_visited_id,
      action: "tree"
      )

      # 自分の投稿に対するコメントの場合は、通知済みとする
      if notification.admin_visitor_id == notification.admin_visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
  end


  # 1_③dエンドユーザー通知機能
  def create_admin_end_notification_tree!(current_user, tree_id, post_id)
      # ◆◆admin_userが投稿したツリー
      # enduser 送信先を所属拠点にもつエンドユーザー、かつ重複を削除
      end_ids = EndUser.where(area_id: post_id, is_deleted: false).ids.uniq
      # nilを削除
      end_ids = end_ids.compact
      # 通知を送られるend_userを、一つずつ取り出し、通知を作成する
      end_ids.each do |end_id|
        # ②通知機能保存に飛ぶ
        save_admin_end_notification_tree!(current_user, tree_id, post_id, end_id)
      end
  end

  # 1_④エンドユーザー通知機能保存
  def save_admin_end_notification_tree!(current_user, tree_id, post_id, end_visited_id)
    notification = current_user.active_notifications.new(
      tree_id: id,
      end_visited_id: end_visited_id,
      action: "tree"
      )
      # 自分の投稿に対するコメントの場合は、通知済みとする
      if notification.end_visitor_id == notification.end_visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
  end





  # 2レスポンスをした時の通帳機能 enduser投稿ツリーの場合
  # 1_①admin通知機能
  def create_end_ad_notification_tree!(current_user, tree_id, area_id, job_id)
      # ◆◆admin_userが投稿したツリー
      # adminuser 担当拠点かつ担当業務に関連するアドミンユーザー
      admin_ids = AdminUser.eager_load(:your_areas, :your_jobs).where(your_areas: {area_id: area_id}).where(your_jobs: {job_id: job_id}).where(is_deleted: false).distinct.ids
      # 重複を削除
      admin_ids = admin_ids.uniq
      # nilを削除
      admin_ids = admin_ids.compact
      # 通知を送られるadmin_userを、一つずつ取り出し、通知を作成する
      admin_ids.each do |admin_id|
        # ②通知機能保存に飛ぶ
        save_end_ad_notification_tree!(current_user, tree_id, area_id, job_id, admin_id)
      end
  end

  # 1_②通知機能保存
  def save_end_ad_notification_tree!(current_user, tree_id, area_id, job_id, admin_visited_id)
    notification = current_user.active_notifications.new(
      tree_id: id,
      admin_visited_id: admin_visited_id,
      action: "tree"
      )

      # 自分の投稿に対するコメントの場合は、通知済みとする
      if notification.admin_visitor_id == notification.admin_visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
  end


  # 1_③エンドユーザー通知機能
  def create_end_end_notification_tree!(current_user, tree_id, area_id)
      # ◆◆admin_userが投稿したツリー
      # enduser 送信先を所属拠点にもつエンドユーザー、かつ重複を削除
      end_ids = EndUser.where(area_id: area_id, is_deleted: false).ids.uniq
      # nilを削除
      end_ids = end_ids.compact
      # 通知を送られるend_userを、一つずつ取り出し、通知を作成する
      end_ids.each do |end_id|
        # ②通知機能保存に飛ぶ
        save_end_end_notification_tree!(current_user, tree_id, area_id, end_id)
      end
  end

  # 1_④エンドユーザー通知機能保存
  def save_end_end_notification_tree!(current_user, tree_id, area_id, end_visited_id)
    notification = current_user.active_notifications.new(
      tree_id: id,
      end_visited_id: end_visited_id,
      action: "tree"
      )
      # 自分の投稿に対するコメントの場合は、通知済みとする
      if notification.end_visitor_id == notification.end_visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
  end

end
