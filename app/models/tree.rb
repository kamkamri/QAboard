class Tree < ApplicationRecord

  # アソシエーション
  #  optional:true  は、belongs_to の外部キーのnilを許可する
  belongs_to :admin_user, optional: true
  belongs_to :end_user, optional: true
  has_many :responses, dependent: :destroy
  belongs_to :area
  # Treeの中のpost_idも、areaとのアソシエーションがあるので、名前をpostと名づける
  belongs_to :post, class_name: "Area"
  belongs_to :job


  # モデルファイルに並び替えを行う
  default_scope -> { order(updated_at: :desc) }

  # 最新レスポンスを1件取得
  has_one :latest_response, -> { order(updated_at: :desc)}, class_name: :Response

end
