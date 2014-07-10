class AddEventToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :event_id, :integer
  end
end
