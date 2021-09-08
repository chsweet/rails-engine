require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
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

  describe 'class methods' do
    describe '::find_all_by_name' do
      it 'finds all items that match the name parameters' do
        value = 'ring'

        expect(Item.find_all_by_name(value)).to eq([@item_4, @item_1, @item_2])
      end
    end

    describe "::find_all_by_min_price" do
      it 'returns all items that are equal to or greater than min_price parameters' do
        value = 4.99

        expect(Item.find_all_by_min_price(value)).to eq([@item_1, @item_3, @item_5, @item_6])
      end
    end

    describe '::find_all_by_max_price' do
      it 'returns all items that are equal to or less than max_price parameters' do
        value = 4.99

        expect(Item.find_all_by_max_price(value)).to eq([@item_1, @item_2, @item_4])
      end
    end

    describe '::items_sorted_by_revenue' do
      it 'returns quantity of items ranked by descending revenue' do
        quantity = 2

        expect(Item.items_sorted_by_revenue(quantity)).to eq([@item_3, @item_4])
      end
    end
  end
end
