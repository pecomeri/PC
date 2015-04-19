class Item < ActiveRecord::Base
  def get_item_xml
    res = Amazon::Ecs.item_search('並行輸入', {:response_group => 'ItemAttributes, OfferSummary, SalesRank', :sort => 'salesrank',
                                   :search_index => 'Toys', :country => 'jp',
                                   :ItemPage => 10})
    res.marshal_dump
  end

  def self.insert_jp_data
    search_index = 'Toys'
    pages = 100
    search_options = {
      response_group: 'ItemAttributes, OfferSummary, SalesRank',
      sort: 'salesrank',
      search_index: search_index, 
      country: 'jp'
    }
   
    pages.times do |page|
      search_options["ItemPage"] = page + 1

      res = Amazon::Ecs.item_search('並行輸入', search_options)
      res.items.each do |item|
        data = Item.new(name: item.get('ItemAttributes/Title'), 
                        asin: item.get('ASIN'), 
                        search_index: search_index, 
                        price_jp: item.get('OfferSummary/LowestNewPrice/Amount'), 
                        rank_amazon: item.get('SalesRank'), 
                        check_date:  Time.now.to_s(:db)
                       )
        data.save
      end
      sleep(2)
    end
  end

  def self.update_us_price
    records = Item.all
    records.each do |record|
      res = Amazon::Ecs.item_lookup(record.asin, :response_group => 'OfferSummary', :country => 'us')
      res.items.each do |item|
        record.price_us = item.get('OfferSummary/LowestNewPrice/Amount').to_i * 1.2
        record.save
      end
      sleep(2)
    end
  end
end
