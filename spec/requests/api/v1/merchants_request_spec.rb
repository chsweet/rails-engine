require 'rails_helper'

describe 'Merchants API' do
  it "sends a list of 20 merchants" do
    create_list(:merchant, 25)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(20)

    merchants.each do |book|
      expect(merchant).to have_key(:name)
      expect(merchant[:id]).to be_an(String)
    end
  end
end
