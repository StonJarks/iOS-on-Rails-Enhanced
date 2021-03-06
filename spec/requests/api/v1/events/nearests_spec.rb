require "spec_helper"

describe 'GET /events/nearests?lat=&lon=&radius=' do
	before(:each) do
		@user = create(:user)
		post "/auth/login", { email: @user.email, password: "secret"}.to_json, set_headers(nil)
		@auth_token = @user.auth_token
	end

	it 'returns the events closest to lat and lon' do
		near_event = create(:event, lat: 37.760322, lon: -122.429667)
		farther_event = create(:event, lat: 37.760321, lon: -122.429667)

		create(:event, lat: 37.687737, lon: -122.470608)

		lat = 37.771098
		lon = -122.430782
		radius = 5

		get "/events/nearests?lat=#{lat}&lon=#{lon}&radius=#{radius}", {}, set_headers(@auth_token)

		expect(response_json).to eq([
			{
				'address' => near_event.address,
				'ended_at' => near_event.ended_at.as_json,
				'id' => near_event.id,
				'lat' => near_event.lat,
				'lon' => near_event.lon,
				'name' => near_event.name,
				'owner' => { 'email' => near_event.owner.email},
				'started_at' => near_event.started_at.as_json,
				'attendancees' => near_event.users.count
				},
			{
				'address' => farther_event.address,
				'ended_at' => farther_event.ended_at.as_json,
				'id' => farther_event.id,
				'lat' => farther_event.lat,
				'lon' => farther_event.lon,
				'name' => farther_event.name,
				'owner' => { 'email' => farther_event.owner.email},
				'started_at' => farther_event.started_at.as_json,
				'attendancees' => farther_event.users.count
			}
		])
	end

	it 'returns an error message when no event is found' do
		lat = 37.771098
		lon = -122.430782
		radius = 1

		get "/events/nearests?lat=#{lat}&lon=#{lon}&radius=#{radius}", {}, set_headers(@auth_token)

		expect(response_json).to eq({'message' => 'No Events Found'})
		expect(response.code.to_i).to eq 200
	end
end