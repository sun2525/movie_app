class MoviesController < ApplicationController
  # ログインが必要なアクションを指定（現在は投稿機能がないため new, create, edit, update, destroy は削除）
  before_action :authenticate_user!, only: [:edit] # `show` には適用しない
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
    # **未ログインの場合、ログインページへリダイレクトし、ログイン後に元の映画詳細ページへ戻す**
    unless user_signed_in?
      store_location_for(:user, request.fullpath) # ← 元のURLを保存
      redirect_to new_user_session_path, alert: "映画の詳細を見るにはログインしてください。"
      return
    end

    # **TMDb API から映画の詳細情報を取得**
    tmdb_service = TmdbApiService.new
    @movie_details = tmdb_service.movie_details(params[:id])
  end

  # **視聴開始処理**
  def start_viewing
    # **すでに視聴中の映画がある場合、削除（1ユーザー1視聴の制限）**
    current_user.viewing&.destroy

    # **新しい視聴データを作成**
    Viewing.create(user: current_user, movie_id: params[:id], active: true)

    redirect_to movie_path(params[:id]), notice: "視聴を開始しました。"
  end

  # **視聴終了処理**
  def stop_viewing
    # **視聴中データを探し、視聴を終了**
    current_user.viewing&.destroy

    redirect_to movie_path(params[:id]), notice: "視聴を終了しました。"
  end

  private

  # **Rails の `movies` テーブルを参照する set_movie メソッド（現在は使わない）**
  def set_movie
    @movie = Movie.find_by(id: params[:id])
    unless @movie
      redirect_to movies_path, alert: "指定された映画は存在しません。"
    end
  end
end
