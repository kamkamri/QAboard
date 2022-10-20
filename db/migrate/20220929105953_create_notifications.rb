class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications, id: :integer do |t|

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

    # response を削除した時、なぜかdependent: :destroyを記入しているのに、
    # notification通知が消えてくれないので、外部きーの設定がうまくいっていない可能性あり
    # 明確に記載してみる　エラーになったので消す
    # add_foreign_key :notifications, :responses

    # indexを貼ることにより、検索速度を早くする
    add_index :notifications, :admin_visitor_id
    add_index :notifications, :admin_visited_id
    add_index :notifications, :end_visitor_id
    add_index :notifications, :end_visited_id
    add_index :notifications, :tree_id
    add_index :notifications, :response_id

  end
end
