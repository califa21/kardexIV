json.array!(@bon_lancements) do |bon_lancement|
  json.extract! bon_lancement, :id
  json.url bon_lancement_url(bon_lancement, format: :json)
end
