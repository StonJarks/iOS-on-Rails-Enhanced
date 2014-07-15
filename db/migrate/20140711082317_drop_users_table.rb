class DropUsersTable < ActiveRecord::Migration
  def up
  	drop_table :users
  end

  def down
  	raise ActiveRecord::IrreversibleMigration
  end
end
