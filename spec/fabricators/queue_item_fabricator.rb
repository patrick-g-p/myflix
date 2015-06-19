Fabricator(:queue_item) do
  list_position {(1..10).to_a.sample}
end
