require 'rails_helper'
RSpec.describe 'Items New API' do
  before :each do
    FactoryBot.reload
  end

  describe 'Happy Path' do
    it 'can create new item' do
      merchant = create(:merchant)
      # items = create(:item)
      # expect(Item.count).to eq(1)

      item_params = {
        name: 'New Item',
        description: 'Shiny & New',
        unit_price: 1.99,
        merchant_id: merchant.id
      }

      post "/api/v1/items", params: item_params
      # expect(response).to have_http_status(201)
      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)
      expect(item[:data][:attributes][:name]).to eq('New Item')
      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
#TODO test for json response hash for Item
#TODO test for status
    end




    # it 'can delete item' do
    # end
  end

  # describe 'Sad Path' do
  #   it '' do
  #   end
  # end
end
