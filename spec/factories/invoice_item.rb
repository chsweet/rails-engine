FactoryBot.define do
  factory :invoice_item do
    quantity { Faker::Number.decimal_part(digits: 2) }
    sequence(:unit_price) { |n| n + 150 }
    invoice
    item
  end
end
