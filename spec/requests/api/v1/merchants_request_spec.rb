require 'rails_helper'

describe 'Merchants API' do
  it "default sends a list of first 20 merchants" do
    create_list(:merchant, 25)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(20)

    merchants.each do |merchant|
      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_an(String)
    end
  end

  it "sends a list of 20 merchants depending on page" do
    create_list(:merchant, 50)

    get '/api/v1/merchants?page=2'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(20)

  end

  it "sends a list of merchants depending on per_page number" do
    create_list(:merchant, 50)

    get '/api/v1/merchants?per_page=30'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(30)
  end
end
