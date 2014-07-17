class EventPolicy
	attr_reader :current_user, :event

	def initialize(current_user, event)
		@current_user = current_user
		@event = event
	end

	def update?
		@current_user == @event.owner
	end
end