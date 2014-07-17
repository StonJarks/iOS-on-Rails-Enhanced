class ApplicationController < ActionController::Base
  
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

   def require_auth
    auth_token = params["auth_token"]
    #auth_token = request.headers["auth_token"]
    @user = User.find_by_auth_token(auth_token)
    if @user
      if @user.auth_token_expired?
        render :status => 401, :json => {:error => "Auth token expired"}
        return false
      end
    else
      render :status => 401, :json => {:error => "Requires authorization"}
      return false
    end
  end


  private

    def user_not_authorized
      render :status => 403, :json => {:error => 'You are not authorized' }
      return false
    end
  # def current_user
  #   User.find_by_auth_token(params["auth_token"])
    
  # end
end
