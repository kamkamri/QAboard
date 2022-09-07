class EndUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  #アソシエーション 
  has_many :trees, dependent: :destroy
  has_many :responses, dependent: :destroy
  belongs_to :area
  
  has_one_attached :profile_image
end
