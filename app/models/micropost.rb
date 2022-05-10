class Micropost < ApplicationRecord
  # microposrとuserを関連づけ
  belongs_to :user
  # デフォルト順序指定
  default_scope -> { order(created_at: :desc) }
  # user_idが存在しているか
  validates :user_id, presence: true
  # 投稿の文字数チェック
  validates :content, presence: true, length: { maximum: 140 }
end
