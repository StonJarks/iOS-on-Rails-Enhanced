class Photo < ActiveRecord::Base
	validates_presence_of :image

	belongs_to :event
	mount_uploader :image, ImageUploader
end
