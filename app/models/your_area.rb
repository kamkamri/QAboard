class YourArea < ApplicationRecord


  # バリデーション
  # validates :area_id, acceptance: true

  # アソシエーション
  belongs_to :admin_user
  belongs_to :area

  # 条件
  # admin　受信した質問1 拠点担当者のarea_idが、自分の担当拠点
  scope :rec_admin_myarea, -> {where(admin_user_id: current_admin_user.id)}
end
