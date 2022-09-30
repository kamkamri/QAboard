class Notification < ApplicationRecord

  default_scope -> { order(created_at: :desc)}
  belongs_to :tree, optional: true
  belongs_to :response, optional: :true

  belongs_to :admin_visitor, class_name: "AdminUser", foreign_key: "admin_visitor_id", optional: true
  belongs_to :admin_visited, class_name: "AdminUser", foreign_key: "admin_visited_id", optional: true
  belongs_to :end_visitor, class_name: "EndUser", foreign_key: "end_visitor_id", optional: true
  belongs_to :end_visited, class_name: "EndUser", foreign_key: "end_visited_id", optional: true

end