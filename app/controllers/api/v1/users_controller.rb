class Api::V1::UsersController < ApiController
	
	before_filter :require_auth, only: [:update, :destroy]
	respond_to :json
	
	def new
		@user = User.new
	end

	api :POST, "/users", "creates a new user"
	param :user, Hash do
		param :email, String
		param :password, String
	end
	example "{ {'email': 'user@example.com', 'password': 'foobar' }"
	def create
		@user = User.new(user_params)
		
		if @user.save
			render :status => 201, :json => {
				:email => @user.email
			}
		else
			render json: {
        		message: 'Validation Failed',
        		errors: @user.errors.full_messages
      		}, status: 422
		end
	end

	api :PATCH, "/users/:id", "updates the users credentials"
	error :code => 422, :desc => "Validation Failed"
	error :code => 403, :desc => "You are not authorized"	
	param :user, Hash do
		param :email, String
		param :password, String	
	end
	example "{'email': 'user@example.com', 'password': 'foobar' }"
	def update
		@user = User.find(params[:id])
		authorize @user

		if @user.update_attributes(user_params)
  			render :status => 200, json: {
          		:id => @user.id
        	}
		else
			render json: {
    			message: 'Validation Failed',
    			errors: @user.errors.full_messages
  			}, status: 422	
  		end
	end

	api :DELETE, "/users/:id", "deletes a users's account"
	param :id, :number
	error :code => 422, :desc => "Could not delete account"
	error :code => 403, :desc => "You are not authorized"
	def destroy
		@user = User.find(params[:id])
		authorize @user
		
		if @user.destroy
			render :status => 200
		else
			render json: {
				message: 'Could not delete account',
				errors: @user.errors.full_messages
			}, status: 422
		end
	end
	private

		def user_params
			{
				email: params[:email],
				password: params[:password]
				#password_confirmation: params[:password_confirmation]
			}
			#params.require(:user).permit(:email, :password, :password_confirmation)
		end
end
