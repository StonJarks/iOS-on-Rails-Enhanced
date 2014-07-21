require 'spec_helper'

describe 'GET /events/:id' do
	it 'returns an event by :id' do
		event = create(:event)
		get "/events/#{event.id}",{}, set_headers
		expect(response_json).to eq(
			{
				'address' => event.address,
				'ended_at' => event.ended_at.as_json,
				'id' => event.id,
				'lat' => event.lat,
				'lon' => event.lon,
				'name' => event.name,
				'started_at' => event.started_at.as_json,
				'owner' => {
					'email' => event.owner.email,
				},
				'attendancees' => event.users.count
			}
		)
	end
end

describe 'POST /events/' do
	context "as a signed in user" do
		before(:each) do
			@user = create(:user)
			post "/auth/login", { email: @user.email, password: "secret"}.to_json, set_headers
			@auth_token = @user.auth_token
		end

		it 'saves the address, lat, lon, name and started_at date' do
			date = Time.zone.now
			owner = create(:user)

			post '/events', {
				address: '123 Example Street',
				ended_at: date,
				lat: 1.0,
				lon: 1.0,
				name: 'Fun Place!',
				started_at: date,
				owner: {
					auth_token: owner.auth_token
				},
				auth_token: @auth_token
			}.to_json, set_headers
			event = Event.last

			expect(response.code.to_i).to eq 201
			expect(response_json).to eq({'id' => event.id})
			expect(event.address).to eq('123 Example Street')
			expect(event.ended_at.to_i).to eq date.to_i
			expect(event.lat).to eq 1.0
			expect(event.lon).to eq 1.0
			expect(event.name).to eq('Fun Place!')
			expect(event.started_at.to_i).to eq date.to_i
			expect(event.owner).to eq owner
		end

		it 'returns an error message when invalid' do

			post '/events', {
				auth_token: @auth_token
				}.to_json, set_headers
			
			expect(response_json).to eq({
				'message' => 'Validation Failed',
				'errors' => [
					"Lat can't be blank",
					"Lon can't be blank",
					"Name can't be blank",
					"Started at can't be blank"
					]
				})
			expect(response.code.to_i).to eq 422
		end
	end

	context "as a not signed in user" do
		it "returns a not authorized message" do

			date = Time.zone.now	

			post '/events', {
					address: '123 Example Street',
					ended_at: date,
					lat: 1.0,
					lon: 1.0,
					name: 'Fun Place!',
					started_at: date,
					owner: {
						auth_token: nil
					},
					auth_token: nil
				}.to_json, set_headers
			expect(response.code.to_i).to eq 401
		end
	end
end

describe 'PATCH /events/:id' do
	before(:each) do
		@user = create(:user)

		post "/auth/login", { email: @user.email, password: "secret"}.to_json, set_headers
		@auth_token = @user.auth_token
	end
	context "as the events owner" do
		it 'updates the event attributes' do
			event = create(:event, owner: @user)
			new_name = 'New name'

			patch "/events/#{event.id}", {
				address: event.address,
				ended_at: event.ended_at,
				lat: event.lat,
				lon: event.lon,
				name: new_name,
				started_at: event.started_at,
				owner: {
					email: event.owner.email
				},
				auth_token: @auth_token
			}.to_json, set_headers
			event.reload

			expect(response.code.to_i).to eq 200
			expect(event.name).to eq new_name
			expect(response_json).to eq({'id' => event.id})
		end
		it 'returns an error message when invalid' do

			event= create(:event, owner: @user)

			patch "/events/#{event.id}", {
				auth_token: @auth_token,
				address: event.address,
				lat: event.lat,
				lon: event.lon,
				ended_at: event.ended_at,
				started_at: event.started_at,
				name: nil,
				owner: {
					email: event.owner.email
				}
			}.to_json, set_headers
			event.reload

			expect(event.name).to_not be nil
			expect(response_json).to eq({
				'message' => 'Validation Failed',
				'errors' => [ "Name can't be blank"]
				})

			expect(response.code.to_i).to eq 422
		end	
	end

	context "when not the event's owner" do
		it "doesn't update the events attributes" do
			event = create(:event)
			new_name = 'New name'

			patch "/events/#{event.id}", {
				address: event.address,
				ended_at: event.ended_at,
				lat: event.lat,
				lon: event.lon,
				name: new_name,
				started_at: event.started_at,
				owner: {
					email: event.owner.email
				},
				auth_token: @auth_token
			}.to_json, set_headers
	
			expect(response.code.to_i).to eq 403
			expect(response_json).to eq({
				'error' => 'You are not authorized'
				})
		end
	end
end