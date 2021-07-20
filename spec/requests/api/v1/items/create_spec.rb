require 'rails_helper'
RSpec.describe 'Items New API' do
  before :each do
    FactoryBot.reload
  end

  describe 'Happy Path' do
    it 'can create new item' do
      merchant = create(:merchant)
      items = create(:item)
      expect(Item.count).to eq(1)

      item_params = {
        name: 'New Item',
        description: 'Shiny & New',
        unit_price: 1.99,
        merchant_id: merchant.id
      }

      post "/api/v1/items", params: item_params
      expect(Item.count).to eq(2)
#TODO how to test for json response hash for Item
#TODO how to test for status
    end

    # it 'can delete item' do
    # end
  end

  # describe 'Sad Path' do
  #   it '' do
  #   end
  # end
end
