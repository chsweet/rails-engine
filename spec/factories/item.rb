FactoryBot.define do
  factory :item do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    unit_price { Faker::Number.within(range: 1..10000) }
    merchant
  end
end
