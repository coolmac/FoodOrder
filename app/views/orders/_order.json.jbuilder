json.extract! order, :id, :address, :user_id, :amount, :created_at, :updated_at
json.url order_url(order, format: :json)
