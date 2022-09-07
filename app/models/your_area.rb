class YourArea < ApplicationRecord
  
  # アソシエーション
  belongs_to :admin_user
  belongs_to :area
end
