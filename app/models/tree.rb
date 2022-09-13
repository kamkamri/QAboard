class Tree < ApplicationRecord

  # アソシエーション
  belongs_to :admin_user
  belongs_to :end_user
  belongs_to :area
  belongs_to :job
  has_many :responses, dependent: :destroy

  # モデルファイルに並び替えを行う
  default_scope -> { order(created_at: :desc) }

end
