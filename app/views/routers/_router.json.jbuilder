json.extract! router, :id, :name, :latitude, :longitude, :created_at, :updated_at
json.url router_url(router, format: :json)
