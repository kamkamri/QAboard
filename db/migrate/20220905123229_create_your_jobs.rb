class CreateYourJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :your_jobs, id: :integer do |t|

      t.integer :admin_user_id, null: false
      t.integer :job_id, null: false

      t.timestamps
    end
  end
end
