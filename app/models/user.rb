class User < ApplicationRecord
    # 読み取り、書き込みの両方を定義できる
    attr_accessor :remember_token
    # callbaxk 保存する前に小文字に変換
    before_save { email.downcase! }
    # nema属性の存在性を検証する
    validates :name, presence: true, length: { maximum: 50 }
    # email属性の存在性を検証する
    # 定数は大文字で宣言
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
        validates :email, presence: true, length: { maximum: 255 },
        # with 正規表現パターン 一致するかどうか
        format: { with: VALID_EMAIL_REGEX },
        # uniqueness 重複していないか
        # case_sensitive 完全一致
        uniqueness: { case_sensitive: false }
    
    # ハッシュ化
    has_secure_password
    # allow_nil 対象の値がnilの時、skipする
    # has_secure_password オブジェクト生成時に存在性を検証しているので、有効になることはない
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    
    # deigest new_token 定義
    class << self
        # 渡された文字列のハッシュ値を返す
        def User.digest(string)
            # コストパラメータ(ハッシュを算出するための)をテスト中は最小に
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                          BCrypt::Engine.cost
            # pass生成
            BCrypt::Password.create(string, cost: cost)
        end
        
        # random tokenを返す
        def User.new_token
            # ランダムな文字列を22文字で返す
            SecureRandom.urlsafe_base64
        end
    end
        
    # 永続セッションのためにユーザーをdbに記憶する
    def remember
        self.remember_token = User.new_token
        # 記憶ダイジェスト更新
        update_attribute(:remember_digest, User.digest(remember_token))
    end
    
    # 渡されたトークンがダイジェストと一致したらtrue返す
    def authenticated?(remember_token)
        # 記憶ダイジェストがnilのときfalse返す
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
    
    # ユーザーのログイン情報を破棄
    def forget
        update_attribute(:remember_digest, nil)
    end
end
