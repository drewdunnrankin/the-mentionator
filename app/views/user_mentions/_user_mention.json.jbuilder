json.extract! user_mention, :id, :username, :mentions, :created_at, :updated_at
json.url user_mention_url(user_mention, format: :json)