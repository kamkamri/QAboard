class Area < ApplicationRecord


  # バリデーション
  validates :name, presence: true


  # アソシエーション
  has_many :your_areas, dependent: :destroy
  # N：Nの関係を追記することにより、中間テーブルにadmin_userを保存した時に一緒にほぞんできるようにする
  has_many :admin_users, through: :your_areas
  has_many :end_users, dependent: :destroy
  has_many :your_areas, dependent: :destroy
  has_many :trees, dependent: :destroy



end
