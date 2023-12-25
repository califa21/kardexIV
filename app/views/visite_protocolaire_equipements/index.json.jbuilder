json.array!(@visite_protocolaire_equipements) do |visite_protocolaire_equipement|
  json.extract! visite_protocolaire_equipement, :id
  json.url visite_protocolaire_equipement_url(visite_protocolaire_equipement, format: :json)
end
