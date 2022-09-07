class CreateResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :responses do |t|

      t.integer :tree_id, null: false
      t.integer :end_user_id
      t.integer :admin_user_id
      t.text :body, null: false

      t.timestamps
    end
  end
end
