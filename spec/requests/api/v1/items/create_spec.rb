require 'rails_helper'
RSpec.describe 'Item Create API' do
  before :each do
    FactoryBot.reload
  end

  describe 'Happy Path' do
    it 'can create new item' do
      merchant = create(:merchant)

      item_params = {
        name: 'New Item',
        description: 'Shiny & New',
        unit_price: 1.99,
        merchant_id: merchant.id
      }

      post "/api/v1/items", params: item_params
      expect(response).to have_http_status(201)

      item = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item[:attributes][:name]).to eq(item_params[:name])
      expect(item[:attributes][:description]).to eq(item_params[:description])
      expect(item[:attributes][:unit_price]).to eq(item_params[:unit_price])
      expect(item[:attributes][:merchant_id]).to eq(item_params[:merchant_id])
    end
  end

  describe 'Sad Path' do
    it 'returns error if attribute is missing' do
      merchant = create(:merchant)
      item_params = {
        name: 'New Item',
        description: 'Shiny & New',
        unit_price: '',
        merchant_id: merchant.id
      }

      post "/api/v1/items", params: item_params

      item = JSON.parse(response.body, symbolize_names: true)
      expect(Item.count).to eq(0)
      expect(item[:data]).to eq(nil)
      expect(item[:errors]).to eq(['Field(s) Missing'])
      expect(response).to have_http_status(:bad_request)
    end
  end
end
