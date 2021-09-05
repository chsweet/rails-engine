require 'rails_helper'

describe 'Merchants API' do
  it "default sends a list of first 20 merchants" do
    create_list(:merchant, 25)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(20)
    expect(merchants[:data]).to be_an(Array)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:id]).to be_an(String)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:id]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_an(String)

    end
  end

  it "sends a list of 20 merchants depending on page" do
    create_list(:merchant, 50)

    get '/api/v1/merchants?page=2'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(20)
    expect(merchants[:data].first[:id]).to_not eq("#{Merchant.first.id}")
    expect(merchants[:data].last[:id]).to_not eq("#{Merchant.last.id}")
  end

  it "sends first 20 merchants if page is 0 or lower" do
    create_list(:merchant, 50)

    get '/api/v1/merchants?page=0'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(20)
    expect(merchants[:data].first[:id]).to eq("#{Merchant.first.id}")
    expect(merchants[:data].last[:id]).to_not eq("#{Merchant.last.id}")
  end

  it "sends a list of merchants depending on per_page number" do
    create_list(:merchant, 50)

    get '/api/v1/merchants?per_page=30'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(30)
    expect(merchants[:data].first[:id]).to eq("#{Merchant.first.id}")
    expect(merchants[:data].last[:id]).to_not eq("#{Merchant.last.id}")
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful
    expect(merchant[:data]).to be_an(Hash)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to eq("#{id}")

    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to be_a(String)

    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to be_a(Hash)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end
end
