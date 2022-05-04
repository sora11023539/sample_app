class SessionsController < ApplicationController
  def new
  end
  
  def create
    # 送信されたemailと同じものを探す
    user = User.find_by(email: params[:session][:email].downcase)
    # passが認証されたら
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        # フォワーディング リクされたURLが存在する場合、そこにリダイレクト ない場合デフォルトURLにリダイレクト
        redirect_back_or user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flas[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    # logged_in?がtrueの場合にlog_outを呼び出す
    log_out if logged_in?
    redirect_to root_url
  end
end
