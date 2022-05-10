class ApplicationController < ActionController::Base
  # session helper読み込み
  include SessionsHelper
  
  private
    # userのloginを確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "please log in."
        redirect_to login_url
      end
    end
end
