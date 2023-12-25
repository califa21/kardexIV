json.array!(@doc_divers) do |doc_diver|
  json.extract! doc_diver, :id
  json.url doc_diver_url(doc_diver, format: :json)
end
