json.array!(@exec_cn_machines) do |exec_cn_machine|
  json.extract! exec_cn_machine, :id
  json.url exec_cn_machine_url(exec_cn_machine, format: :json)
end
