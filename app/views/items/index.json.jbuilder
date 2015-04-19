json.array!(@items) do |item|
  json.extract! item, :id, :name, :asin, :search_index, :price_jp, :price_us, :rank_amazon, :check_date
  json.url item_url(item, format: :json)
end
