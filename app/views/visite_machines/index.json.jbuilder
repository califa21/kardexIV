json.array!(@visite_machines) do |visite_machine|
  json.extract! visite_machine, :id
  json.url visite_machine_url(visite_machine, format: :json)
end
