class Attendance < ActiveRecord::Base

	validates_presence_of :user
	validates_presence_of :event

	validates :event_id, uniqueness: { scope: :user_id }

	belongs_to :event
	belongs_to :user
end
