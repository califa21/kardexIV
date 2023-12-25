json.array!(@potentiel_machines) do |potentiel_machine|
  json.extract! potentiel_machine, :id
  json.url potentiel_machine_url(potentiel_machine, format: :json)
end
