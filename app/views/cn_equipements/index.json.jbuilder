json.array!(@cn_equipements) do |cn_equipement|
  json.extract! cn_equipement, :id
  json.url cn_equipement_url(cn_equipement, format: :json)
end
