class MoviesController < ApplicationController
  # ログインが必要なアクションを指定（現在は投稿機能がないため new, create, edit, update, destroy は削除）
  before_action :authenticate_user!, only: [:edit]
  before_action :set_movie, only: [:edit] # show では使わない
  before_action :redirect_if_not_owner, only: [:edit]

  # **トップページ（映画一覧）**
  def index
    # **Rails の movies テーブルを取得（投稿機能削除後は使用しない）**
    # @movies = Movie.includes(:user).order(created_at: :desc) ← 一旦コメントアウト（今後の掲示板機能で使うかも）

    # **TMDb API から最新映画・おすすめ映画を取得**
    tmdb_service = TmdbApiService.new
    @latest_movies = tmdb_service.fetch_latest_movies # 最新の映画
    @recommended_movies = tmdb_service.fetch_popular_movies # 人気の映画
    # 🔍 検索結果を取得
    if params[:query].present?
      @search_results = tmdb_service.search_movies(params[:query]) # TMDb APIで映画検索
    else
      @search_results = [] # 検索結果がない場合は空の配列を設定
    end
  end

  # **映画の詳細ページ**
  def show
    tmdb_service = TmdbApiService.new
    @movie_details = tmdb_service.movie_details(params[:id]) # TMDb API から映画の詳細情報を取得
  end

  private

  # **Rails の `movies` テーブルを参照する set_movie メソッド（現在は使わない）**
  def set_movie
    @movie = Movie.find_by(id: params[:id])
    unless @movie
      redirect_to movies_path, alert: "指定された映画は存在しません。"
    end
  end

  # **投稿機能を削除したため、movie_params メソッドも現在は不要**
  # def movie_params
  #   params.require(:movie).permit(:title, :description, :streaming_url, :image)
  # end

  # **投稿機能を削除したため、編集権限チェックも不要**
  # def redirect_if_not_owner
  #   return if current_user == @movie&.user
  #   redirect_to movies_path, alert: "この操作は許可されていません"
  # end
end
