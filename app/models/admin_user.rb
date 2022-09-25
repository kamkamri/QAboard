class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  # バリデーション
  validates :employee_number, presence: true, numericality: true, uniqueness: true, length: {is: 6}
  validates :family_name, presence: true
  validates :first_name, presence: true
  validates :area_id, presence: true
  # 関連テーブルyour_areaのvalidatesをかける
  # validates_associated :関連テーブル名
  # validates :関連テーブル名, validatesの内容
  validates_associated :your_areas
  validates :your_areas, presence: true

  # 関連テーブルyour_jobのvalidatesをかける
  # validates_associated :関連テーブル名
  # validates :関連テーブル名, validatesの内容
  validates_associated :your_jobs
  validates :your_jobs, presence: true


  # validates :your_areas, area_id: {presence: true}
  # validates :job_ids, acceptance: true

  # アソシエーション
  has_many :your_areas, dependent: :destroy
  # N：Nの関係を追記することにより、中間テーブルにadmin_userを保存した時に一緒にほぞんできるようにする
  has_many :areas, through: :your_areas # 担当拠点
  has_many :your_jobs, dependent: :destroy
  # N：Nの関係を追記することにより、中間テーブルにadmin_userを保存した時に一緒にほぞんできるようにする
  has_many :jobs, through: :your_jobs
  has_many :trees, dependent: :destroy
  has_many :responses, dependent: :destroy

  belongs_to :area  # 所属拠点

  # プロフィール画像
  has_one_attached :profile_image
  
  ## 条件
  # admin　受信した質問1 拠点担当者のarea_idが、自分の担当拠点
  has_many :rec_admin_yourareas, ->{rec_admin_myarea}, class_name: "YourArea"
  has_many :rec_admin_area, through: :rec_admin_yourareas

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

  # 関連付けしたモデルを一緒にデータ保存できるようにする
  # accepts_nested_attributes_for :your_areas, allow_destroy: true  # fields_for（後述）に必要
  # accepts_nested_attributes_for :your_jobs, allow_destroy: true  # fields_for（後述）に必要

end
