class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :address
      t.datetime :ended_at
      t.float :lat
      t.float :lon
      t.string :name
      t.datetime :started_at
      t.integer :user_id

      t.timestamps
    end

    add_index :events, :user_id
  end
end
