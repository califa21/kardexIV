json.array!(@type_equipements) do |type_equipement|
  json.extract! type_equipement, :id
  json.url type_equipement_url(type_equipement, format: :json)
end
