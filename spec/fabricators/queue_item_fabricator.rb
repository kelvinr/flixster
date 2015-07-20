Fabricator(:queue_item) do
  position { (1..30).to_a.sample }
end
