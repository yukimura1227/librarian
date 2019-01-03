json.extract! book, :id, :title, :location, :order_id, :created_at, :updated_at
json.url book_url(book, format: :json)
