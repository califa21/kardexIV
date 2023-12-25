json.array!(@est_monte_surs) do |est_monte_sur|
  json.extract! est_monte_sur, :id
  json.url est_monte_sur_url(est_monte_sur, format: :json)
end
