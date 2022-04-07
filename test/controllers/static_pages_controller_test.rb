require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  # テストが実行される前に実行されるメソッド
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
  
  # home pageに入ったとき、レスポンスはsuccessになるはず
  test "should get home" do
    get static_pages_home_url
    assert_response :success
    # 特定のhtmlタグがあるかどうかチェック
    assert_select "title", "Home | #{@base_title}"
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end
  
  test "should get contact" do
    get static_pages_contact_url
    assert_response :success
    assert_select "title", " | #{@base_title}"
  end
end
