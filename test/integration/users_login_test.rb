require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "login with invalid information" do
    get login_path # login page に入る
    assert_template 'sessions/new' # 新しいセッションが正しく表示されるか
    post login_path, params: { session: { email: "", password: "" } } # あえて無効なparams ハッシュを使いpostする
    assert_not flash.empty? # flash messsage が追加されることを確認
    get root_path # 別ページに移動
    assert flash.empty? # flash message が表示されていないか
  end
end
