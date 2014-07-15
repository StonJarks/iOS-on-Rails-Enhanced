require "spec_helper"

describe 'POST /v1/attendances' do
	before(:each) do
		@user = create(:user)
		post "/v1/auth/login", { email: @user.email, password: "secret"}.to_json, { 'Content-Type' => 'application/json'}
		@auth_token = @user.auth_token
		#login_user_post(@user.email, 'secret')
	end
	it 'creates an attendance for a user and event' do
		event = create(:event)
		#user = create(:user)

		post '/v1/attendances', {
			event: { id: event.id },
			user: { auth_token: @auth_token }
		}

		expect(event.reload.attendances.count).to eq 1
	end

	it 'only allows a user to RSVP once per event' do
		event = create(:event)
		#user = create(:user)

		2.times do
			post 'v1/attendances', {
				event: { id: event.id },
				user: {auth_token: @auth_token }
			}
		end

		expect(event.reload.attendances.count).to eq 1
	end
end