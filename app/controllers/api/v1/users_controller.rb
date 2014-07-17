class Api::V1::UsersController < ApiController
	
	before_filter :require_auth, only: [:update, :destroy]
	
	def new
		@user = User.new
	end

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
