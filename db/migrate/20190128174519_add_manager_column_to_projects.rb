class AddManagerColumnToProjects < ActiveRecord::Migration[5.0]
  def change
  	add_column :projects, :manager, :integer
  end
end
