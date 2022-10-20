class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs, id: :integer do |t|

      t.string :name, null: false
      t.boolean :is_deleted, null: false, default: false
      t.string :color, null: false

      t.timestamps
    end
  end
end
