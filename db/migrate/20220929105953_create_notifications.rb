class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|

      t.integer :admin_visitor_id
      t.integer :admin_visited_id
      t.integer :end_visitor_id
      t.integer :end_visited_id
      t.integer :tree_id
      t.integer :response_id
      t.string :action, default: "", null: false
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
    
    add_index :notifications, :admin_visitor_id
    add_index :notifications, :admin_visited_id
    add_index :notifications, :end_visitor_id
    add_index :notifications, :end_visited_id
    add_index :notifications, :tree_id
    add_index :notifications, :response_id
    
  end
end
