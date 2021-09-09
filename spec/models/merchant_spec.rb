require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:invoices) }
    it { should have_many(:items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

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
    @invoice_item_3 = create(:invoice_item, invoice: Invoice.fourth, item: Item.fourth, quantity: 10, unit_price: 1.00)
    @invoice_item_4 = create(:invoice_item, invoice: Invoice.fifth, item: Item.fifth, quantity: 10, unit_price: 1.00)

    @transaction_1 = create(:transaction, invoice: Invoice.first)
    @transaction_2 = create(:transaction, invoice: Invoice.second)
    @transaction_3 = create(:transaction, invoice: Invoice.third)
    @transaction_4 = create(:transaction, invoice: Invoice.fourth)
    @transaction_5 = create(:transaction, result: 'failed', invoice: Invoice.fifth)
  end

  describe 'class methods' do
    describe '::find_by_params' do
      it 'return the first object based off of user query parameters' do
        value = 'ring'

        expect(Merchant.find_first_by_name(value)).to eq(@merchant_4)
      end
    end

    describe '::merchant_sorted_by_revenue' do
      it 'returns merchants sorted by revenue and the number of the merchants passed in from the params' do
        quantity = 3

        expect(Merchant.merchant_sorted_by_revenue(quantity)).to eq([@merchant_3, @merchant_4, @merchant_2])
      end
    end

    describe '::merchant_items_sold' do
      it 'returns a variable number of merchants ranked by total number of items sold' do
        quantity = 3

        result = Merchant.merchant_items_sold(quantity).map do |merchant|
                          merchant.name
                        end

        expect(result).to eq([@merchant_3.name, @merchant_4.name, @merchant_2.name])
      end
    end
  end

  describe 'instance methods' do
    describe '#merchant_revenue' do
      it 'returns merchants sorted by revenue and the number of the merchants passed in from the params' do
        expect(@merchant_2.merchant_revenue).to eq(5.00)
      end
    end
  end
end
