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

  has_one_attached :profile_image

  # 関連付けしたモデルを一緒にデータ保存できるようにする
  # accepts_nested_attributes_for :your_areas, allow_destroy: true  # fields_for（後述）に必要
  # accepts_nested_attributes_for :your_jobs, allow_destroy: true  # fields_for（後述）に必要

end
