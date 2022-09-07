class Area < ApplicationRecord
  
  # アソシエーション
  has_many :admin_users, dependent: :destroy
  has_many :end_users, dependent: :destroy
  has_many :your_areas, dependent: :destroy
  has_many :trees, dependent: :destroy
end
