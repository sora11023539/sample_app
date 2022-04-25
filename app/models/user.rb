class User < ApplicationRecord
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
    
    # 最小文字数
    validates :password, presence: true, length: { minimum: 6 }
end
