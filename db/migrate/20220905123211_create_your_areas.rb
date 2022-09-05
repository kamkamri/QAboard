class CreateYourAreas < ActiveRecord::Migration[6.1]
  def change
    create_table :your_areas do |t|

      t.timestamps
    end
  end
end
