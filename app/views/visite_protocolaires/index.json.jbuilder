json.array!(@visite_protocolaires) do |visite_protocolaire|
  json.extract! visite_protocolaire, :id
  json.url visite_protocolaire_url(visite_protocolaire, format: :json)
end
