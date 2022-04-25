require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # testが走る前に実行@userがこのtest内で使えるように「
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
    password: "foobar", password_confirmation: "foobar")
  end
  
  # Userオブジェクトが有効であるか
  test "should be valid" do
    # assert trueであった場合
    assert @user.valid?
  end
  
  # 渡された属性が存在するか
  test "name should be present" do
    # 空白の文字列をセット
    @user.name = ""
    # Userオブジェクトが有効でなくなったか
    # assert_not falseであった場合
    assert_not @user.valid?
  end
  
  # 渡された属性が存在するか
  test "email should be present" do
    # 空白の文字列をセット
    @user.email = ""
    # Userオブジェクトが有効でなくなったか
    assert_not @user.valid?
  end
  
  # name属性の長さ制限
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  # email属性の長さ制限
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  # emailフォーマット検証
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org 
    first.last@foo.jp alice+bob@baz.cn]
    
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  # 無効なメールアドレス
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
        foo@bar_baz.com foo@bar+baz.com]
        
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  # 重複するemail拒否
  test "email addresses should be unique" do
    # dup 同じ属性を持つデータを複製
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  # 小文字にするテスト
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    # assert_equal 値が一致しているか
    # reload dbの値に合わせて更新する
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  # pass 空でない
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  # pass 6文字以上
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
