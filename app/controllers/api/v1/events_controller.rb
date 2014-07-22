class Api::V1::EventsController < ApiController

  before_filter :require_auth, only: [:create, :update]
	respond_to :json
	
  api :GET, '/events/:id', "List a event"
  param :id, :number, required: true
  example " 'adress': '123 Example Street','started_at': 'Mon, 21 Jul 2014 14:50:18 UTC +00:00 ', 'lat': '-1.0', 'lon': '-1.0', 'name': 'Great Event', 'ended_at': 'Mon, 22 Jul 2014 14:50:18 UTC +00:00', 'owner': {'auth_token': '1234abcd567'} "
  def show
		@event = Event.find(params[:id])
	end

  api :POST, '/events', "Creates a new event"
  error :code => 422, :desc => "Validation Failed"
  error :code => 403, :desc => "You are not authorized"
  error :code => 401, :desc => "Auth token expired"
  error :code => 401, :desc => "Requires authorization"
  param :event, Hash, :desc => "Event parameters", :required => true do
    param :address, String, :required => true
    param :lat, :number, :desc => "Latitude", :required => true
    param :lon, :number, :desc => "Longitude", :required => true
    param :name, String, :desc => "Name of the event", :required => true
    param :started_at, Date, :desc => "Start date json formatted", :required => true
    param :ended_at, Date, :desc => "Start date json formatted", :required => true
    param :owner, Hash do
      param :auth_token, String, :desc => "User auth_token", :required => true  
    end
  end
  example " 'adress': '123 Example Street','started_at': 'Mon, 21 Jul 2014 14:50:18 UTC +00:00 ', 'lat': '-1.0', 'lon': '-1.0', 'name': 'Great Event', 'ended_at': 'Mon, 22 Jul 2014 14:50:18 UTC +00:00', 'owner': {'auth_token': '1234abcd567'} "
  example " 'message'; 'Validation Failed',
            'errors': ['Lon can't be blank'] "
	def create
  	@event = Event.new(event_params)

  	if @event.save
    		render :status => 201, json: {
          :id => @event.id
        }
  	else
    		render json: {
      		message: 'Validation Failed',
      		errors: @event.errors.full_messages
    		}, status: 422
  	end
	end

  api :PATCH, '/events/:id', "Edits a event"
  error :code => 422, :desc => "Validation Failed"
  error :code => 403, :desc => "You are not authorized"
  param :event, Hash, :desc => "Event parameters", :required => true do
    param :address, String, :required => true
    param :lat, :number, :desc => "Latitude", :required => true
    param :lon, :number, :desc => "Longitude", :required => true
    param :name, String, :desc => "Name of the event", :required => true
    param :started_at, Date, :desc => "Start date json formatted", :required => true
    param :ended_at, Date, :desc => "Start date json formatted", :required => true
    param :owner, Hash do
      param :auth_token, String, :desc => "User auth_token", :required => true
    end
  end
  example " 'adress': '123 Example Street','started_at': 'Mon, 21 Jul 2014 14:50:18 UTC +00:00 ', 'lat': '-1.0', 'lon': '-1.0', 'name': 'Great Event', 'ended_at': 'Mon, 22 Jul 2014 14:50:18 UTC +00:00', 'owner': {'auth_token': '1234abcd567'} "
	example "  'message'; 'Validation Failed',
              'errors': ['Lon can't be blank'] "
  def update
		@event = Event.find(params[:id])
    authorize @event
		
    if @event.update_attributes(event_params)
			render :status => 200, json: {
        :id => @event.id
      }
	  else
			render json: {
  			message: 'Validation Failed',
  			errors: @event.errors.full_messages
			}, status: 422	
		end
	end

private

  def event_params
    {
      address: params[:address],
      ended_at: params[:ended_at],
      lat: params[:lat],
      lon: params[:lon],
      name: params[:name],
      started_at: params[:started_at],
      owner: user
    }
  end

  def user
    User.find_or_create_by(auth_token: auth_token)
  end

  def auth_token
    params[:owner].try(:[], :auth_token)
  end
end
