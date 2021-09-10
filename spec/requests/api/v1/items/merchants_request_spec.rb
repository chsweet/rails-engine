require 'rails_helper'

describe 'Items Merchants API' do
  it 'finds the merchant info for a specific item' do
    merchant_1 = create(:merchant)
    item = create(:item, merchant_id: merchant_1.id)
    id = item.id

    get "/api/v1/items/#{id}/merchant"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant[:data]).to be_an(Hash)

    expect(merchant[:data][:id]).to eq("#{merchant_1.id}")
    expect(merchant[:data][:type]).to eq("merchant")
    expect(merchant[:data][:attributes][:name]).to eq("#{merchant_1.name}")
  end
end
