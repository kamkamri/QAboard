class Area < ApplicationRecord


  # バリデーション
  validates :name, presence: true


  # アソシエーション
  has_many :your_areas, dependent: :destroy
  # N：Nの関係を追記することにより、中間テーブルにadmin_userを保存した時に一緒にほぞんできるようにする
  has_many :admin_users, through: :your_areas
  has_many :end_users
  # has_many :your_areas, dependent: :destroy
  has_many :trees, dependent: :destroy
  # Treeの中の、post_id(送信先)もareaを使うのでpostと命名
  has_many :post, class_name: "Tree", foreign_key: "post_id"
  has_many :area_member, class_name: "AdminUser", foreign_key: "area_id"



end
