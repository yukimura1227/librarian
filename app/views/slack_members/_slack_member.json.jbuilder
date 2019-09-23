json.extract! slack_member, :id, :slack_id, :slack_user_name, :user_id, :created_at, :updated_at
json.url slack_member_url(slack_member, format: :json)
