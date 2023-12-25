json.array!(@potentiel_equipements) do |potentiel_equipement|
  json.extract! potentiel_equipement, :id
  json.url potentiel_equipement_url(potentiel_equipement, format: :json)
end
