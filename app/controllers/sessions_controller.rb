class SessionsController < ApplicationController
  def new
  end
  
  def create
    # 送信されたemailと同じものを探す
    @user = User.find_by(email: params[:session][:email].downcase)
    # passが認証されたら
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to @user
    else
      # flash.now リクエストが発生したら消える
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new' # new view 出力
    end
  end
  
  def destroy
    # logged_in?がtrueの場合にlog_outを呼び出す
    log_out if logged_in?
    redirect_to root_url
  end
end
