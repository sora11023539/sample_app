module SessionsHelper
  
  # 渡されたユーザーidでlogin
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # user のセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 現在ログイン中のユーザーを返す
  def current_user
    # user idにuser idのセッションを代入した結果
    if (user_id = session[:user_id])
      # 一時セッションからユーザーを取り出す
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # 渡されたユーザーがカレントユーザーであればtrue返す
  def current_user?(user)
    user && user == current_user
  end
  
  # userがログインしていればtrue,その他ならfalse
  def logged_in?
    !current_user.nil?
  end
  
  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # 現在のユーザーをログアウト
  def log_out
    # forgetヘルパーメソッド呼び出し
    forget(current_user)
    # sessionからuse_id削除 nilに
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 記憶したURLにリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    # 転送用のURL削除
    session.delete(:forwarding_url)
  end
  
  # アクセスしようとしたURLを覚えておく
  def store_location
    # request.original_url リクエスト先取得
    session[:forwarding_url] = request.original_url if request.get?
  end
end
