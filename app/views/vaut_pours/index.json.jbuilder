json.array!(@vaut_pours) do |vaut_pour|
  json.extract! vaut_pour, :id
  json.url vaut_pour_url(vaut_pour, format: :json)
end
