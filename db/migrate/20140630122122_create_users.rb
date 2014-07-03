class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :device_token

      t.timestamps
    end
  end
end
