class CreateAreas < ActiveRecord::Migration[6.1]
  def change
    create_table :areas, id: :integer do |t|

      t.string :name, null: false
      t.boolean :admin_area_flag, null: false, default: false
      t.boolean :is_deleted, null: false, default: false

      t.timestamps
    end
  end
end
