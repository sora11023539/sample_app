class Micropost < ApplicationRecord
  # microposrとuserを関連づけ
  belongs_to :user
  # 指定のモデルとアップロードファイルを関連づける
  has_one_attached :image
  # デフォルト順序指定
  default_scope -> { order(created_at: :desc) }
  # user_idが存在しているか
  validates :user_id, presence: true
  # 投稿の文字数チェック
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                   message: "must be avalid image format" },
                   size:         { less_than: 5.megabytes,
                                   message: "should be less than 5MB" }
  # resize                                 
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
