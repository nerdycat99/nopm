class AddOrgIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :org_id, :integer
    add_index :users, :org_id
  end  
end
