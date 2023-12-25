json.array!(@visite_equipements) do |visite_equipement|
  json.extract! visite_equipement, :id
  json.url visite_equipement_url(visite_equipement, format: :json)
end
