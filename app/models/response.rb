class Response < ApplicationRecord

  # アソシエーション
  #  optional:true  は、belongs_to の外部キーのnilを許可する
  belongs_to :tree
  belongs_to :admin_user, optional: true
  belongs_to :end_user, optional: true
end
