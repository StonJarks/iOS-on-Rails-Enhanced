require "spec_helper"

describe 'POST /attendances' do
	before(:each) do
		@user = create(:user)
		post "/auth/login", { email: @user.email, password: "secret"}.to_json, set_headers(nil)
		@auth_token = @user.auth_token
	end
	it 'creates an attendance for a user and event' do
		event = create(:event)

		post '/attendances', {
			event: { id: event.id },
			user: { auth_token: @auth_token }
		}.to_json, set_headers(@auth_token)

		expect(event.reload.attendances.count).to eq 1
	end

	it 'only allows a user to RSVP once per event' do
		event = create(:event)

		2.times do
			post '/attendances', {
				event: { id: event.id },
				user: {auth_token: @auth_token }
			}.to_json, set_headers(@auth_token)
		end

		expect(event.reload.attendances.count).to eq 1
	end
end