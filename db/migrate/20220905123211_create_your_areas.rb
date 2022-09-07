class CreateYourAreas < ActiveRecord::Migration[6.1]
  def change
    create_table :your_areas do |t|

      t.integer :admin_user_id, null: false
      t.integer :area_id, null: false

      t.timestamps
    end
  end
end
