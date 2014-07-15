module Sorcery
  module TestHelpers
    module Rails
    	module LoginUserPost
      def login_user_post(user, password)
        page.driver.post(v1_auth_login_url, { username: user, password: password}) 
      end
  end
    end
  end
end

# module AuthHelper
#   def http_login(login, password)
#     request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(login, password)
#   end
# end
 
# module AuthRequestHelper
#   #
#   # pass the @env along with your request, eg:
#   #
#   # GET '/labels', {}, @env
#   #
#   def http_login(login, password)
#     @env ||= {}
#     @env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(login, password)
#   end
# end