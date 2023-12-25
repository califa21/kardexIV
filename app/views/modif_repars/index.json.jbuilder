json.array!(@modif_repars) do |modif_repar|
  json.extract! modif_repar, :id
  json.url modif_repar_url(modif_repar, format: :json)
end
