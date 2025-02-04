class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.string :streaming_url
      t.string :api_movie_id

      t.timestamps
    end
  end
end
