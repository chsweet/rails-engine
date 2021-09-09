require 'rails_helper'

describe 'Revenue Items API' do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)
    @merchant_4 = create(:merchant)
    @merchant_5 = create(:merchant)

    @invoice_1 = create(:invoice, merchant: Merchant.first)
    @invoice_2 = create(:invoice, merchant: Merchant.second)
    @invoice_3 = create(:invoice, merchant: Merchant.third)
    @invoice_4 = create(:invoice, merchant: Merchant.fourth)
    @invoice_5 = create(:invoice, merchant: Merchant.fifth)

    @item_1 = create(:item, name: 'Ring World Banner', unit_price: 4.99, merchant: Merchant.first)
    @item_2 = create(:item, name: 'Turing Tee', unit_price: 3.99, merchant: Merchant.second)
    @item_3 = create(:item, name: 'Dog Collar', unit_price: 5.99, merchant: Merchant.third)
    @item_4 = create(:item, name: 'Ring Ring Song', unit_price: 2.50, merchant: Merchant.fourth)
    @item_5 = create(:item, name: 'Slap Band', unit_price: 6.50, merchant: Merchant.fifth)
    @item_6 = create(:item, unit_price: 7.00)

    @invoice_item_1 = create(:invoice_item, invoice: Invoice.second, item: Item.second, quantity: 5, unit_price: 1.00)
    @invoice_item_2 = create(:invoice_item, invoice: Invoice.third, item: Item.third, quantity: 10, unit_price: 1.50)
    @invoice_item_3 = create(:invoice_item, invoice: Invoice.fourth, item: Item.fourth, quantity: 10, unit_price: 1.00)
    @invoice_item_4 = create(:invoice_item, invoice: Invoice.fifth, item: Item.fifth, quantity: 10, unit_price: 1.00)

    @transaction_1 = create(:transaction, invoice: Invoice.first)
    @transaction_2 = create(:transaction, invoice: Invoice.second)
    @transaction_3 = create(:transaction, invoice: Invoice.third)
    @transaction_4 = create(:transaction, invoice: Invoice.fourth)
    @transaction_5 = create(:transaction, result: 'failed', invoice: Invoice.fifth)
  end

  it 'returns params quantity of items ranked by descending revenue' do
    get '/api/v1/revenue/items?quantity=2'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    # require "pry";binding.pry
    expect(items[:data].count).to eq(2)
    expect(items[:data]).to be_an(Array)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item_revenue")

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_an(Hash)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_an(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_an(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_an(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)

      expect(item[:attributes]).to have_key(:revenue)
      expect(item[:attributes][:revenue]).to be_an(Float)
    end
  end

  xit 'returns default of 10 of items ranked by descending revenue if quantity is not given' do
    get '/api/v1/revenue/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(10)
    expect(items[:data]).to be_an(Array)
  end

  it 'returns 400 error if quantity is a string' do
    get "/api/v1/revenue/items?quantity='2'"

    expect(response).to have_http_status(400)
  end

  it 'returns 400 error if quantity is blank' do
    get '/api/v1/revenue/items?quantity='

    expect(response).to have_http_status(400)
  end
end
