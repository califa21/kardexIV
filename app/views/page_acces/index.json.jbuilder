json.array!(@page_acces) do |page_acce|
  json.extract! page_acce, :id
  json.url page_acce_url(page_acce, format: :json)
end
