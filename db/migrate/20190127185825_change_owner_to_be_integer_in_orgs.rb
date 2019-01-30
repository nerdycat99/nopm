class ChangeOwnerToBeIntegerInOrgs < ActiveRecord::Migration[5.0]
  def change
  	change_column :orgs, :owner, 'integer USING CAST(owner AS integer)'
  end
end
