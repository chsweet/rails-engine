FactoryBot.define do
  factory :transaction do
    credit_card_number { "#{Faker::Business.credit_card_number.delete('-')}" }
    credit_card_expiration_date { "#{Faker::Business.credit_card_expiry_date}/#{Faker::Number.between(from: 21, to: 25)}" }
    result { 'success' }
    invoice
  end
end
