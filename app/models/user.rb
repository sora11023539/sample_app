class User < ApplicationRecord
    # micropostを複数所有する関連づけ
    has_many :microposts, dependent: :destroy
    # 読み取り、書き込みの両方を定義できる
    attr_accessor :remember_token, :activation_token, :reset_token
    # callbaxk 保存する前に小文字に変換
    before_save :downcase_email
    # メソッド参照 メソッドを探し、ユーザー作成の前に実行
    before_create :create_activation_digest
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
    
    # tokenがdigestと一致したらtrueを返す
    # 他の認証でも使えるように第二引数でtoken
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end
    
    # アカウントを有効にする
    def activate
        update_columns(activated: true, activated_at: Time.zone.now)
    end
    
    # 有効化用のメールを送信する
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end
    
    # pass再設定の属性を追加
    def create_reset_digest
        self.reset_token = User.new_token
        update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    end
    
    # pass再設定のメールを送信する
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end
    
    # pass再設定の期限が切れている場合はtrue
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end
    
    # 試作 feedの定義
    # 完全な実装は次章の「ユーザーをフォローする」を参照
    def feed
        Micropost.where("user_id = ?", id)
    end
    
    private
    
    # emailを全て小文字に
    def downcase_email
        self.email = email.downcase
    end
    
    # 有効化トークンとダイジェストを作成及び代入
    def create_activation_digest
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
    end
end
