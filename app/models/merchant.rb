class Merchant < ApplicationRecord
  validates :name, presence: true
  has_many :items
  has_many :invoices

  self.per_page = 20

  def self.find_first_by_name(value)
    Merchant.where("name ~* ?", value).order(:name).first
  end
end
