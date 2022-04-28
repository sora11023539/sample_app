class UsersController < ApplicationController
  
  # showアクション
  def show
    # @user変数定義
    # find dbからユーザーを取り出
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    # 保存されたら
    if @user.save
      # loginする
      log_in @user
      # flash 1回のみ succsessにメッセージ
      flash[:success] = "Welcome to the Sample App!"
      # redirect_to user_url(@user)と等価
      # ユーザー情報ページにリダイレクト
      redirect_to @user
    else
      render 'new'
    end
  end
  
  # 外部から使えないように
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
        :password_confirmation)
    end
end
