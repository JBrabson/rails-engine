class ItemSerializer
  include JSONAPI::Serializer
  #type: dnifds_dbids
  attributes :name, :description, :unit_price, :merchant_id
end
