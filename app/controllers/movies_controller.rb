class MoviesController < ApplicationController
  # ログイン状態でのみアクセス可能なアクションを指定
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  # 映画の詳細・編集・削除時に対象の映画を取得する
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  # 投稿者以外はアクセスできないようにリダイレクトするbefore_action
  before_action :redirect_if_not_owner, only: [:edit, :update, :destroy]

  # 映画一覧を表示するアクション（トップページ）
  def index
    @movies = Movie.includes(:user).order(created_at: :desc) # 映画を取得して新しい順に表示
  
    # 検索クエリが存在する場合にTMDb APIを使って映画情報を取得
    if params[:search].present?
      tmdb_service = TmdbApiService.new
      @search_results = tmdb_service.search_movies(params[:search])
    end
  end
  

  # 映画の詳細ページ
  def show
  end

  # 新規投稿ページを表示
  def new
    @movie = Movie.new
  end

  # 映画を投稿する処理
  def create
    @movie = current_user.movies.build(movie_params)  # current_user を利用
    if @movie.save
      redirect_to movies_path, notice: "映画を投稿しました！"
    else
      render :new, status: :unprocessable_entity  # 投稿ページを再表示
    end
  end

  # 映画編集ページ
  def edit
  end

  # 映画情報を更新
  def update
    if @movie.update(movie_params)  # 入力データを更新
      redirect_to movies_path, notice: "映画情報を更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 映画を削除する処理
  def destroy
    @movie.destroy  # データベースから削除
    redirect_to movies_path, notice: "映画を削除しました！"
  end

  private

  # 指定された映画を取得するメソッド（`before_action` で使用）
  def set_movie
    @movie = Movie.find(params[:id])
  end

  # フォームから送信されたパラメータを許可する
  def movie_params
    params.require(:movie).permit(:title, :description, :streaming_url, :image)
  end

  # 投稿者以外をトップページにリダイレクト
  def redirect_if_not_owner
    return if current_user == @movie.user # 投稿者が一致していれば処理を進める

    # 投稿者でなければ映画一覧ページにリダイレクト
    redirect_to movies_path, alert: "この操作は許可されていません"
  end
end
