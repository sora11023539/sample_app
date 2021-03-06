require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  # 無効なユーザー登録されていたとき
  test "invalid signup information" do
    # user登録ページにアクセス
    get signup_path
    # 呼び出し前と後でuser数に差異がない
    assert_no_difference 'User.count' do
      # フォームに入力された内容を送信
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password:             "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password" } }
    end
    # postリクエストを送信した結果によって、指定されたusers/showに移動
    follow_redirect!
    assert_template 'users/show'
    # test user がloginしているか
    assert is_logged_in?
  end
end

