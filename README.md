## データベース設計

### Users テーブル

| Column              | Type   | Options                   |
|---------------------|--------|---------------------------|
| name                | string | null: false               |
| email               | string | null: false, unique: true |
| encrypted_password  | string | null: false               |

#### Association

- has_many :movies
- has_many :chats

### Movies テーブル

| Column             | Type       | Options                        |
|--------------------|------------|--------------------------------|
| title              | string     | null: false                    |
| description        | text       |                                |
| user               | references | null: false, foreign_key: true | 
| streaming_ur       | string     |                                | 
| api_movie_id       | string     |                                | 


#### Association

- belongs_to :user
- has_many :chats

### Chats テーブル
| Column         | Type       | Options                        |
|----------------|------------|--------------------------------|
| content        | text       | null: false                    |
| user           | references | null: false, foreign_key: true |
| item           | references | null: false, foreign_key: true |

#### Association

- belongs_to :user
- belongs_to :movie