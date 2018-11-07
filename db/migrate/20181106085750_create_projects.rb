class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.string :status
      t.string :org_id
      t.timestamps
    end
  add_index :projects, :org_id
  end
end
