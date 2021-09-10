require 'rails_helper'

describe 'Merchants Items API' do
  it 'finds the items info for a specific merchant' do
    merchant = create(:merchant)
    id = merchant.id
    item_1 = create(:item, merchant_id: merchant.id)
    item_2 = create(:item, merchant_id: merchant.id)
    item_3 = create(:item, merchant_id: merchant.id)
    item_4 = create(:item)

    get "/api/v1/merchants/#{id}/items"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items[:data].count).to eq(3)
    expect(items[:data].first[:id]).to eq("#{item_1.id}")
    expect(items[:data].last[:id]).to eq("#{item_3.id}")
  end

end
