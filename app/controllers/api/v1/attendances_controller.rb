class Api::V1::AttendancesController < ApiController

	api :POST, "/attendances", "creates an attendance for a user and event"
	error :code => 422, :desc => "Validation Failed"
	param :attendance, Hash do
		param :event, Hash do
			param :id, :number, required: true
		end
		param :user, Hash do
			param :auth_token, String, required: true
		end
	end
	example " { 'event' : { 'id': '5'}, 'user' : { 'auth_token': '1234abcd567'} }"
	def create
		event = Event.find(params[:event][:id])
		user = User.find_by(auth_token: params[:user][:auth_token])

		Attendance.create(event: event, user: user)
	end
end
