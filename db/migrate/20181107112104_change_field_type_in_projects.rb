class ChangeFieldTypeInProjects < ActiveRecord::Migration[5.0]
  def change
    change_column :projects, :org_id, 'integer USING CAST(org_id AS integer)'
  end
end
