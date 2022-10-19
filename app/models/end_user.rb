class EndUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリデーション
  validates :employee_number, presence: true, numericality: true, uniqueness: true, length: {is: 6}
  validates :family_name, presence: true
  validates :first_name, presence: true
  validates :area_id, presence: true


  #アソシエーション
  has_many :trees, dependent: :destroy
  has_many :responses, dependent: :destroy
  belongs_to :area

  has_one_attached :profile_image

  # 通知機能
  # 自分からの通知
  has_many :active_notifications, class_name: "Notification", foreign_key: "end_visitor_id", dependent: :destroy
  # 相手からの通知
  has_many :passive_notifications, class_name: "Notification", foreign_key: "end_visited_id", dependent: :destroy

   # 画像がない場合のno-image設定、画像リサイズ
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_fill: [width, height]).processed
  end

  # 氏名を表示するメソッド
  def name_display
    family_name + "　" + first_name
  end

  # 氏名を表示するメソッド短い
  def name_display_short
    family_name + first_name
  end

end
