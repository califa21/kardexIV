json.array!(@cn_machines) do |cn_machine|
  json.extract! cn_machine, :id
  json.url cn_machine_url(cn_machine, format: :json)
end
