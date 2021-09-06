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

  describe 'class methods' do
    describe "::find_all_by_name" do
      it "finds all items that match the name parameters" do
        item_1 = create(:item, name: "Ring World Banner")
        item_2 = create(:item, name: "Turing Tee")
        item_3 = create(:item, name: "Dog Collar")
        item_4 = create(:item, name: "Ring Ring Song")
        item_5 = create(:item, name: "Slap Band")

        value = 'ring'

        expect(Item.find_all_by_name(value)).to eq([item_4, item_1, item_2])
      end
    end

    describe "::find_all_by_min_price" do
      it "returns all items that are equal to or greater than min_price parameters" do
        item_1 = create(:item, unit_price: 4.99)
        item_2 = create(:item, unit_price: 3.99)
        item_3 = create(:item, unit_price: 5.99)
        item_4 = create(:item, unit_price: 2.50)
        item_5 = create(:item, unit_price: 6.50)
        item_6 = create(:item, unit_price: 7.00)

        value = 4.99

        expect(Item.find_all_by_min_price(value)).to eq([item_1, item_3, item_5, item_6])
      end
    end

    describe "::find_all_by_max_price" do
      it "returns all items that are equal to or less than max_price parameters" do
        item_1 = create(:item, unit_price: 4.99)
        item_2 = create(:item, unit_price: 3.99)
        item_3 = create(:item, unit_price: 5.99)
        item_4 = create(:item, unit_price: 2.50)
        item_5 = create(:item, unit_price: 6.50)
        item_6 = create(:item, unit_price: 7.00)

        value = 4.99

        expect(Item.find_all_by_max_price(value)).to eq([item_1, item_2, item_4])
      end
    end
  end
end
