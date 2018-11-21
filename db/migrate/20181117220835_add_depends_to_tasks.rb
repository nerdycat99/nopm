class AddDependsToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :deptasks, :integer, array: true, default: []
  end
end
