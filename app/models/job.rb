class Job < ApplicationRecord

  # アソシエーション
  has_many :your_jobs, dependent: :destroy
  has_many :trees, dependent: :destroy
end
