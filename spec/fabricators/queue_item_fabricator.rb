Fabricator(:queue_item) do |f|
  f.list_position { (1..10).to_a.sample }
end
