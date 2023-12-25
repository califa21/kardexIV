json.array!(@piece_changees) do |piece_changee|
  json.extract! piece_changee, :id
  json.url piece_changee_url(piece_changee, format: :json)
end
