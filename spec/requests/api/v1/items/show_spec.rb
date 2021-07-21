require 'rails_helper'
RSpec.describe 'Items Show API' do
  before :each do
    FactoryBot.reload
  end

  describe 'Happy Path' do
    it 'returns one item by id' do
      create(:merchant)
      create_list(:item, 10)

      get '/api/v1/items/7'
      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)
      expect(item.count).to eq(1)
      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_a(String)
      expect(item[:data][:id]).to eq('7')
      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  describe 'Sad Path' do
    it 'returns 404 with invalid id' do
      create(:merchant)
      create_list(:item, 10)
      item_id = "10"
      get '/api/v1/items/11'
      expect(response).to have_http_status(404)

      get "/api/v1/items/#{item_id}"
      expect(response).to have_http_status(404)
    end
  end
end
