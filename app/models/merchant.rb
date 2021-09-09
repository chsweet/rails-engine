class Merchant < ApplicationRecord
  validates :name, presence: true
  has_many :items
  has_many :invoices

  self.per_page = 20

  def self.find_first_by_name(value)
    order(:name).find_by("name ~* ?", value)
  end

  def self.merchant_sorted_by_revenue(quantity)
    # joins(items: { invoice_items: { invoice: :transactions }})
    joins(invoices: :transactions)
    .joins(invoices: :invoice_items)
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .where("transactions.result = 'success' AND invoices.status = 'shipped'")
    .group('merchants.id')
    .order('revenue DESC')
    .limit(quantity)
  end

  def self.merchant_items_sold(quantity)
    # require "pry";binding.pry
    joins(items: { invoice_items: { invoice: :transactions }})
    .select('merchants.*, sum(invoice_items.quantity) as count')
    .where("transactions.result = 'success'")    .group('merchants.id')
    .order('count DESC')
    .limit(quantity)
  end

  def merchant_revenue
    invoices.joins(:transactions, :invoice_items)
    .where("transactions.result = 'success' AND invoices.status = 'shipped'")
    .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
