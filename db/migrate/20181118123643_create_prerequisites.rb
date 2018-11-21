class CreatePrerequisites < ActiveRecord::Migration[5.0]
  def change
    create_table :prerequisites do |t|
      t.integer :task_id
      t.integer :dependency_id
      t.timestamps
    end
  end
end
