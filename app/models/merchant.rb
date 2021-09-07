class Merchant < ApplicationRecord
  validates :name, presence: true
  has_many :items
  has_many :invoices

  self.per_page = 20

  def self.find_first_by_name(value)
    Merchant.where("name ~* ?", value).order(:name).first
  end

  def self.merchant_sorted_by_revenue(quantity)
    require "pry";binding.pry
    joins(items: [invoices: :transactions])
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price/100.0) as revenue')
    .where("transactions.result = 'success'")
    .group('merchants.id')
    .order('revenue DESC')
    .limit(quantity)
  end
end
