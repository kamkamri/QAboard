class CreateYourJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :your_jobs do |t|

      t.timestamps
    end
  end
end
