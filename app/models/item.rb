class Item < ActiveRecord::Base
  def get_item_xml
    res = Amazon::Ecs.item_search('LEGO', {:search_index => 'Toys', :country => 'jp'})
    res.marshal_dump
  end

  def self.insert_jp_data
    res = Amazon::Ecs.item_search('LEGO', {:response_group => 'Medium', :sort => 'salesrank',
                                   :search_index => 'Toys', :country => 'jp'})

    res.items.each do |item|
      data = Item.new
      data.name = item.get('ItemAttributes/Title')
      data.asin = item.get('ASIN')
      data.search_index = 'Books'
      data.price_jp = item.get('ItemAttributes/ListPrice/Amount')
      data.rank_amazon = item.get('SalesRank')
      data.check_date = Time.now.to_s(:db)
      data.save
    end
  end

  def self.update_us_price
    data = Item.first
    res = Amazon::Ecs.item_lookup(data.asin, :response_group => 'Medium', :country => 'us')
    res.items.each do |item|
    end
    res.marshal_dump
  end
end
