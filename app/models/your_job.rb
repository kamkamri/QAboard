class YourJob < ApplicationRecord
  belongs_to :admin_user
  belongs_to :job
end
