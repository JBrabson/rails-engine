class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  validates_presence_of :name

  def self.find_by_name(name)
    where("name ILIKE ?", "%#{name}%").order(:name).first
  end
end
