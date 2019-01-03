json.extract! order, :id, :title, :order_time, :state, :url, :created_at, :updated_at
json.url order_url(order, format: :json)
