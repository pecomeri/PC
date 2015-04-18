class Item < ActiveRecord::Base
  def getItem
    Amazon::Ecs.options = {
      :associate_tag => Rails.application.secrets.associate_tag,
      :AWS_access_key_id => Rails.application.secrets.AWS_access_key_id,
      :AWS_secret_key => Rails.application.secrets.AWS_secret_key
    }

    res = Amazon::Ecs.item_search('ruby', {:response_group => 'Medium', :sort => 'salesrank'})
    
    res.marshal_dump
  end
end
