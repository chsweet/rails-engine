class InvoiceItem < ApplicationRecord
  validates :quantity, presence: true
  validates :unit_price, presence: true
  belongs_to :invoice
  belongs_to :item
end
