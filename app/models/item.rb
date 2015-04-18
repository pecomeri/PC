class Item < ActiveRecord::Base
  def get_item_xml
    Amazon::Ecs.options = {
      :associate_tag => Rails.application.secrets.associate_tag,
      :AWS_access_key_id => Rails.application.secrets.AWS_access_key_id,
      :AWS_secret_key => Rails.application.secrets.AWS_secret_key
    }

    res = Amazon::Ecs.item_search('ruby', {:response_group => 'Medium', :sort => 'salesrank',
                                   :country => 'jp'})
    res.marshal_dump


  end

  def self.getItem
    Amazon::Ecs.options = {
      :associate_tag => Rails.application.secrets.associate_tag,
      :AWS_access_key_id => Rails.application.secrets.AWS_access_key_id,
      :AWS_secret_key => Rails.application.secrets.AWS_secret_key
    }

    res = Amazon::Ecs.item_search('ruby', {:response_group => 'Medium', :sort => 'salesrank',
                                   :country => 'jp'})

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
    
    res.marshal_dump
  end
end
