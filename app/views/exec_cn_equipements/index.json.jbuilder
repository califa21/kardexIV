json.array!(@exec_cn_equipements) do |exec_cn_equipement|
  json.extract! exec_cn_equipement, :id
  json.url exec_cn_equipement_url(exec_cn_equipement, format: :json)
end
