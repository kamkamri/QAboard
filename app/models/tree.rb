class Tree < ApplicationRecord

  # アソシエーション
   #  optional:true  は、belongs_to の外部キーのnilを許可する
  belongs_to :admin_user, optional: true
  belongs_to :end_user, optional: true
  belongs_to :area
  belongs_to :job
  has_many :responses, dependent: :destroy

  # モデルファイルに並び替えを行う
  default_scope -> { order(created_at: :desc) }

end
