json.array!(@type_machines) do |type_machine|
  json.extract! type_machine, :id
  json.url type_machine_url(type_machine, format: :json)
end
