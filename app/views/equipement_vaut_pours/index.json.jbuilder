json.array!(@equipement_vaut_pours) do |equipement_vaut_pour|
  json.extract! equipement_vaut_pour, :id
  json.url equipement_vaut_pour_url(equipement_vaut_pour, format: :json)
end
