class CreateOrgs < ActiveRecord::Migration[5.0]
  def change
    create_table :orgs do |t|
      t.string :name
      t.string :description
      t.string :owner
      t.string :email
      t.timestamps
    end
  end
end
