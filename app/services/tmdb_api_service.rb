require 'httparty'

class TmdbApiService
  BASE_URL = "https://api.themoviedb.org/3"

  def initialize(api_key = ENV['TMDB_API_KEY'])
    @api_key = api_key
  end

  # 映画を検索するメソッド
  def search_movies(query, language = "ja-JP")
    response = HTTParty.get(
      "#{BASE_URL}/search/movie",
      query: {
        api_key: @api_key,
        query: query,
        language: language
      }
    )
    handle_response(response)
  end

  # 映画の詳細を取得するメソッド
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

  # レスポンスを処理するヘルパーメソッド
  def handle_response(response)
    if response.code == 200
      JSON.parse(response.body)
    else
      { error: "Failed to fetch data", status: response.code, message: response.message }
    end
  end
end
