class Api::V1::AttendancesController < ApiController

	def create
		event = Event.find(params[:event][:id])
		user = User.find_by(auth_token: params[:user][:auth_token])

		Attendance.create(event: event, user: user)
	end
end
