class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.float :duration
      t.datetime :due_date
      t.string :status
      t.integer :user_id
      t.integer :project_id
      t.timestamps
    end
    add_index :tasks, :project_id
    add_index :tasks, :user_id
  end
end
