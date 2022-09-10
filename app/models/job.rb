class Job < ApplicationRecord

  # バリデーション
  validates :name, presence: true

  # アソシエーション
  has_many :your_jobs, dependent: :destroy
  # N：Nの関係を追記することにより、中間テーブルにadmin_userを保存した時に一緒にほぞんできるようにする
  has_many :admin_users, through: :your_jobs
  has_many :trees, dependent: :destroy
end
