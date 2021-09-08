class MerchantSerializer
  include   FastJsonapi::ObjectSerializer
  set_type :object
  attributes :name

  def self.merchant_name_revenue(merchants)
    {
      data:
        merchants.map do |merchant|
          {
            id: "#{merchant.id}",
            type: "merchant_name_revenue",
            attributes: {
              name: "#{merchant.name}",
              revenue: merchant.revenue
            }
          }
        end
    }
  end

  def self.merchant_revenue(merchant)
    {
      data:
          {
            id: "#{merchant.id}",
            type: "merchant_revenue",
            attributes: {
              revenue: merchant.merchant_revenue
            }
          }
    }
  end
end
