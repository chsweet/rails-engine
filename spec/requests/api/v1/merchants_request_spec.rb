require 'rails_helper'

describe 'Merchants API' do
  it 'default sends a list of first 20 merchants' do
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
      expect(merchant[:type]).to be_an(String)
      expect(merchant[:type]).to eq("merchant")

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_an(Hash)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_an(String)
    end
  end

  it 'sends a list of 20 merchants depending on page' do
    create_list(:merchant, 41)

    get '/api/v1/merchants?page=2'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(20)
    expect(merchants[:data].first[:id]).to_not eq("#{Merchant.first.id}")
    expect(merchants[:data].last[:id]).to_not eq("#{Merchant.last.id}")
  end

  it 'sends first 20 merchants if page is 0 or lower' do
    create_list(:merchant, 41)

    get '/api/v1/merchants?page=0'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(20)
    expect(merchants[:data].first[:id]).to eq("#{Merchant.first.id}")
    expect(merchants[:data].last[:id]).to_not eq("#{Merchant.last.id}")
  end

  it 'sends a list of merchants depending on per_page number' do
    create_list(:merchant, 41)

    get '/api/v1/merchants?per_page=30'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(30)
    expect(merchants[:data].first[:id]).to eq("#{Merchant.first.id}")
    expect(merchants[:data].last[:id]).to_not eq("#{Merchant.last.id}")
  end

  it 'can get one merchant by its id' do
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

  xit 'returns 404 error is merchant id does not exist' do
    get "/api/v1/merchants/89451357"

    expect(response.status).to eq(404)
  end

  it 'return the first object based off of user query parameters' do
    merchant_1 = create(:merchant, name: 'Ring World')
    merchant_2 = create(:merchant, name: 'Turing')
    merchant_3 = create(:merchant, name: 'Pet Shop')
    merchant_4 = create(:merchant, name: 'Ring Ring')

    get '/api/v1/merchants/find?name=ring'

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant[:data]).to be_an(Hash)
    expect(merchant[:data][:id]).to eq("#{merchant_4.id}")
    expect(merchant[:data][:attributes][:name]).to eq("#{merchant_4.name}")
  end

  it 'return null object if user query parameters have no match' do
    merchant_1 = create(:merchant, name: 'Ring World')
    merchant_2 = create(:merchant, name: 'Turing')
    merchant_3 = create(:merchant, name: 'Pet Shop')
    merchant_4 = create(:merchant, name: 'Ring Ring')

    get '/api/v1/merchants/find?name=dog'

    expect(response).to be_successful
  end

  it 'returns 400 response if user query parameters are not complete' do
    merchant_1 = create(:merchant, name: 'Ring World')
    merchant_2 = create(:merchant, name: 'Turing')
    merchant_3 = create(:merchant, name: 'Pet Shop')
    merchant_4 = create(:merchant, name: 'Ring Ring')

    get '/api/v1/merchants/find?name='

    expect(response).to have_http_status(400)
  end

  it 'returns 400 response if user query parameters are missing' do
    merchant_1 = create(:merchant, name: 'Ring World')
    merchant_2 = create(:merchant, name: 'Turing')
    merchant_3 = create(:merchant, name: 'Pet Shop')
    merchant_4 = create(:merchant, name: 'Ring Ring')

    get '/api/v1/merchants/find'

    expect(response).to have_http_status(400)
  end

  it 'returns a variable number of merchants ranked by total number of items sold' do
    @merchant_1 = create(:merchant, name: 'Ring World')
    @merchant_2 = create(:merchant, name: 'Turing')
    @merchant_3 = create(:merchant, name: 'Pet Shop')
    @merchant_4 = create(:merchant, name: 'Ring Ring')
    @merchant_5 = create(:merchant, name: 'Potato')

    @invoice_1 = create(:invoice, merchant: Merchant.first)
    @invoice_2 = create(:invoice, merchant: Merchant.second)
    @invoice_3 = create(:invoice, merchant: Merchant.third)
    @invoice_4 = create(:invoice, merchant: Merchant.fourth)
    @invoice_5 = create(:invoice, merchant: Merchant.fifth)

    @item_1 = create(:item, merchant: Merchant.first)
    @item_2 = create(:item, merchant: Merchant.second)
    @item_3 = create(:item, merchant: Merchant.third)
    @item_4 = create(:item, merchant: Merchant.fourth)
    @item_5 = create(:item, merchant: Merchant.fifth)

    @invoice_item_1 = create(:invoice_item, invoice: Invoice.second, item: Item.second, quantity: 5, unit_price: 1.00)
    @invoice_item_2 = create(:invoice_item, invoice: Invoice.third, item: Item.third, quantity: 10, unit_price: 1.50)
    @invoice_item_2 = create(:invoice_item, invoice: Invoice.fourth, item: Item.fourth, quantity: 10, unit_price: 1.00)
    @invoice_item_3 = create(:invoice_item, invoice: Invoice.fifth, item: Item.fifth, quantity: 10, unit_price: 1.00)

    @transaction_1 = create(:transaction, invoice: Invoice.first)
    @transaction_2 = create(:transaction, invoice: Invoice.second)
    @transaction_3 = create(:transaction, invoice: Invoice.third)
    @transaction_4 = create(:transaction, invoice: Invoice.fourth)
    @transaction_5 = create(:transaction, result: 'failed', invoice: Invoice.fifth)

    get '/api/v1/merchants/most_items?quantity=2'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    # require "pry";bindings.pry
    expect(merchants[:data].count).to eq(2)
    expect(merchants[:data]).to be_an(Array)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("items_sold")

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_an(Hash)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:count)
      expect(merchant[:attributes][:count]).to be_an(Integer)
    end
  end
end
