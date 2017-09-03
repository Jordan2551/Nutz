json.extract! article, :id, :description, :img_url, :user_id, :created_at, :updated_at
json.url article_url(article, format: :json)
