require 'rails_helper'

describe 'Revenue Merchants API' do
  before :each do
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
  end

  it 'returns a variable number of merchents ranked by total revenue' do
    get '/api/v1/revenue/merchants?quantity=2'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    # require "pry";binding.pry
    expect(merchants[:data].count).to eq(2)
    expect(merchants[:data]).to be_an(Array)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_an(String)
      expect(merchant[:type]).to eq("merchant_name_revenue")

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_an(Hash)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:revenue)
      expect(merchant[:attributes][:revenue]).to be_an(Float)
    end
  end

  xit 'returns 400 error if quantity is a string' do
    get "/api/v1/revenue/merchants?quantity='2'"

    expect(response).to have_http_status(400)
  end

  xit 'returns 400 error if quantity is blank' do
    get '/api/v1/revenue/merchants?quantity='

    expect(response).to have_http_status(400)
  end

  xit 'returns 400 error if params are missing' do
    get '/api/v1/revenue/merchants'

    expect(response).to have_http_status(400)
  end

  it 'returns a specific merchant revenue' do
    get "/api/v1/revenue/merchants/#{@merchant_2.id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to be_an(Hash)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_an(String)

    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to eq("merchant_revenue")

    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to be_an(Hash)

    expect(merchant[:data][:attributes]).to have_key(:revenue)
    expect(merchant[:data][:attributes][:revenue]).to be_an(Float)
  end
end
