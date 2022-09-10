class YourJob < ApplicationRecord

  # バリデーション
  # validates :job_id, acceptance: true

  # アソシエーション
  belongs_to :admin_user
  belongs_to :job
end
