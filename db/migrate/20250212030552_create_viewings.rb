class CreateViewings < ActiveRecord::Migration[7.1]
  def change
    create_table :viewings do |t|
      # ユーザーの参照カラム（外部キー制約あり）
      # null: false -> 必ずユーザーが関連付く必要がある
      # foreign_key: true -> usersテーブルとのリレーションを作成
      t.references :user, null: false, foreign_key: true

      # TMDbの映画IDを保存するカラム（文字列）
      t.string :movie_id

      # 視聴中かどうかを管理するカラム（true: 視聴中, false: 視聴終了）
      t.boolean :active

      # created_at と updated_at を自動で管理するカラム
      t.timestamps
    end
  end
end
