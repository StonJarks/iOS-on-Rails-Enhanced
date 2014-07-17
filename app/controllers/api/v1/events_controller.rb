class Api::V1::EventsController < ApiController

  before_filter :require_auth, only: [:create, :update]
	respond_to :json
	
	def show
		@event = Event.find(params[:id])
	end

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
