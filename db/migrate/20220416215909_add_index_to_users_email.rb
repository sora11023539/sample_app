class AddIndexToUsersEmail < ActiveRecord::Migration[6.0]
  # emailの一意性を強制する
  def change
    # add_index インデックスを追加
    add_index :users, :email, unique: true
  end
end
