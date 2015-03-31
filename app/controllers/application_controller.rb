class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

private

    def check_token
      hashtext = JSON.parse(params.first[0])
      user = User.find_by(google_credentials: hashtext['google_credentials'])
      unless user.chrome_token == hashtext['chrome_token']
        render status: 401 and return
      end
    end
end
