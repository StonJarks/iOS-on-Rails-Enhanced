class Api::V1::Events::NearestsController < ApiController
	
	api :GET, '/events/nearests?lat=#{lat}&lon=#{lon}&radius=#{radius}', "returns the events closest to lat and lon"
	param :event, Hash do
		param :lat, :number, desc: "Latitude", required: true
		param :lon, :number, desc: "Longitude", required: true
		param :radius, :number, desc: "Radius in km", required: true
	end
	example "[{'address' : '85 2nd Street', 'ended_at' : '2013-09-17T00:00:00.000Z', 'lat' : 37.8050217, 'lon' : -122.409155, 'name' : 'Best event EVERRR!', 'started_at' : '2013-09-16T00:00:00.000Z', 'owner' : { 'email' : 'user@example.com' }, {'address' : '88 2nd Street', 'ended_at' : '2013-09-17T00:00:00.000Z', 'lat' : 37.8050217, 'lon' : -122.409155, 'name' : 'some other event', 'started_at' : '2013-09-16T00:00:00.000Z', 'owner' : { 'email' : 'user2@example.com' }}]"
	def index
		@events = Event.near([params[:lat], params[:lon]], params[:radius], units: :km)
		
		if @events.count(:all) > 0
			render
		else
			render json: { message: 'No Events Found'}, status: 200
		end
	end
end