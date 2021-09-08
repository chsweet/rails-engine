class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  self.per_page = 20

  def self.find_all_by_name(value)
    Item.where("name ~* ?", value).order(:name)
  end

  def self.find_all_by_min_price(value)
    Item.where("unit_price >= ?", value)
  end

  def self.find_all_by_max_price(value)
    Item.where("unit_price <= ?", value.to_f)
  end

  def self.item_revenue(quantity)
    joins(:invoice_items, merchant: [invoices: :transactions])
    .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .where("transactions.result = 'success' AND invoices.status = 'shipped'")
    .group('items.id')
    .order('revenue DESC')
    .limit(quantity)
  end
end
