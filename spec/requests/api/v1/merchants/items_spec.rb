require 'rails_helper'
RSpec.describe "Merchant's Items API" do
  before :each do
    FactoryBot.reload
    merchant = create(:merchant)
    items = create_list(:item, 7, merchant: merchant)
    get '/api/v1/merchants/1/items'
  end

  describe 'Happy Path' do
    it "returns list of merchant's items" do
      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data].class).to eq(Array)
      expect(items[:data].count).to eq(7)
      items[:data].each do |item|
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end
  end

  describe 'Sad Path' do
    it 'returns 404 with invalid id' do
      merchant = create(:merchant)
      items = create_list(:item, 7, merchant: merchant)
      get "/api/v1/merchants/#{merchant.id + 1}/items"
      expect(response).to have_http_status(404)
    end
  end
end
