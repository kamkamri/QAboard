class YourArea < ApplicationRecord


  # バリデーション
  # validates :area_id, acceptance: true

  # アソシエーション
  belongs_to :admin_user
  belongs_to :area
end
