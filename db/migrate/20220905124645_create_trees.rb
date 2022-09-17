class CreateTrees < ActiveRecord::Migration[6.1]
  def change
    create_table :trees do |t|

      t.integer :end_user_id
      t.integer :admin_user_id
      t.integer :area_id, null: false
      t.integer :post_id, null: false
      t.integer :job_id, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.boolean :is_closed, null: false, default: false

      t.timestamps
    end
    # post_idは、areaに関連するので外部きーとして追加
    add_foreign_key :trees, :areas, column: :post_id
  end
end
