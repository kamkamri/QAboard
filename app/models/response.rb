class Response < ApplicationRecord
  
  # アソシエーション
  belongs_to :tree
  belongs_to :admin_user
  belongs_to :end_user
end
