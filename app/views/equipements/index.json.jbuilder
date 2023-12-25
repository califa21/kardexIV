json.array!(@equipements) do |equipement|
  json.extract! equipement, :id
  json.url equipement_url(equipement, format: :json)
end
