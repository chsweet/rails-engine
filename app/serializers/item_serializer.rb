class ItemSerializer
  include   FastJsonapi::ObjectSerializer
  set_type :object
  attributes :name, :description, :unit_price, :merchant_id
end
