require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:invoices) }
    it { should have_many(:items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'class methods' do
    describe '::find_by_params' do
      it 'return the first object based off of user query parameters' do
        merchant_1 = create(:merchant, name: "Ring World")
        merchant_2 = create(:merchant, name: "Turing")
        merchant_3 = create(:merchant, name: "Pet Shop")
        merchant_4 = create(:merchant, name: "Ring Ring")

        key = 'name'
        value = 'ring'

        expect(Merchant.find_first_by_name(value)).to eq(merchant_4)
      end
    end
  end

end
