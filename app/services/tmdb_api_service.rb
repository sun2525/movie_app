require 'httparty'

class TmdbApiService
  BASE_URL = "https://api.themoviedb.org/3"

  def initialize(api_key = ENV['TMDB_API_KEY'])
    @api_key = api_key
  end

  # 🎬 最新映画を取得
  def fetch_latest_movies(language = "ja-JP")
    response = HTTParty.get(
      "#{BASE_URL}/movie/now_playing",
      query: {
        api_key: @api_key,
        language: language,
        page: 1
      }
    )
    handle_response(response)
  end

  # ⭐ 人気映画（おすすめ映画）を取得
  def fetch_popular_movies(language = "ja-JP")
    response = HTTParty.get(
      "#{BASE_URL}/movie/popular",
      query: {
        api_key: @api_key,
        language: language,
        page: 1
      }
    )
    handle_response(response)
  end

  # 🔍 映画検索メソッド
  def search_movies(query, language = "ja-JP")
    response = HTTParty.get(
      "#{BASE_URL}/search/movie",
      query: {
        api_key: @api_key,
        language: language,
        query: query,
        page: 1
      }
    )
    handle_response(response)
  end

  # 🎞️ 映画の詳細を取得
  def movie_details(movie_id, language = "ja-JP")
    response = HTTParty.get(
      "#{BASE_URL}/movie/#{movie_id}",
      query: {
        api_key: @api_key,
        language: language
      }
    )
    handle_response(response)
  end

  private

  # 🛠️ レスポンスを処理するメソッド
  def handle_response(response)
    begin
      if response.code == 200
        body = JSON.parse(response.body)
        body["results"] || body # `results` がなければそのまま返す
      else
        Rails.logger.error "❌ TMDb API エラー: #{response.code} - #{response.message} | レスポンス: #{response.body}"
        []
      end
    rescue JSON::ParserError => e
      Rails.logger.error "🚨 JSON パースエラー: #{e.message} | レスポンス: #{response.body}"
      []
    rescue StandardError => e
      Rails.logger.error "🚨 予期しないエラー: #{e.message}"
      []
    end
  end
end
