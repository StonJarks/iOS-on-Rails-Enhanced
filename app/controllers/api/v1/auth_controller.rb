class Api::V1::AuthController < ApiController
 # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  before_filter :validate_params, :only => :authenticate

  api :POST, "/auth/login", "logs in a user"
  error :code => 422, :desc => "Invalid credentials"
  param :user, Hash do
    param :email, String, required: true
    param :password, String, required: true
  end
  example "{'email': 'user@example.com', 'password': 'foobar'} "
  def authenticate
    @user = login(params[:email], params[:password])
    if @user
      
      ttl = params[:ttl].blank? ? 600 : params[:ttl].to_i
      
      @user.regenerate_auth_token!(ttl.seconds.from_now) if @user.auth_token_expired?
      
      render :status => 201, :json => {
        :email => @user.email,
        :auth_token => @user.auth_token,
        :auth_token_expires_at => @user.auth_token_expires_at.to_json
      }
    else
      render :status => 422, :json => {:error => "Invalid credentials"}
    end
  end

  private

  def validate_params
    if params[:email].blank? || params[:password].blank?
      render :status => 422, :json => {:error => "email & password parameters are required"}
      return false
    end
  end
end