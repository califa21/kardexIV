json.array!(@carnets) do |carnet|
  json.extract! carnet, :id
  json.url carnet_url(carnet, format: :json)
end
