json.array!(@personnes) do |personne|
  json.extract! personne, :id
  json.url personne_url(personne, format: :json)
end
