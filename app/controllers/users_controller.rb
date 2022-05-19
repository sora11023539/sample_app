class UsersController < ApplicationController
  # only 指定したアクションにだけフィルタ適用されるように
  before_action :logged_in_user, only: [:edit, :update, :destroy, :following, :followers]
  # 別のユーザーのプロフィールを編集しようとするとリダイレクトさせる
  before_action :correct_user, only: [:edit, :update]
  # destroyアクションを管理者だけに
  before_action :admin_user, only: :destroy
  
  # showアクション
  def show
    # @user変数定義
    # find dbからユーザーを取り出
    # params httpのパラメーター
    @user = User.find(params[:id])
  end
  
  def new
    # Userモデルをもとに空のUserを
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    # 保存されたら
    if @user.save
      # mail送信
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def index
    @users = User.where(activated: true.pagenate(page:params[:page]))
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    # microposts変数をwill_pagenateに渡す
    @microposts = @user.microposts.paginate(page: params[:page])
    # and == &&よりも優先度高い
    redirect_to root_url and return unless @user.activated?
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  # 外部から使えないように
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
  
  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end