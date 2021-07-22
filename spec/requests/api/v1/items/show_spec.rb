require 'rails_helper'
RSpec.describe 'Items Show API' do
  before :each do
    FactoryBot.reload
    Merchant.destroy_all
    Item.destroy_all
  end

  describe 'Happy Path' do
    it 'returns one item by id' do
      merchant = create(:merchant)
      10.times do |index|
        Item.create!(name: "Item-#{index + 1}", description: Faker::GreekPhilosophers.quote, unit_price: Faker::Commerce.price, merchant: merchant)
      end

      item1 = Item.first
      get "/api/v1/items/#{item1.id}"

      item = JSON.parse(response.body, symbolize_names: true)
      expect(item.count).to eq(1)
      expect(item[:data][:id]).to eq("#{item1.id}")
      expect(item[:data][:attributes][:name]).to eq("#{item1.name}")
      expect(item[:data][:attributes][:description]).to eq("#{item1.description}")
      expect(item[:data][:attributes][:unit_price]).to eq(item1.unit_price)
      expect(item[:data][:attributes][:merchant_id]).to eq(item1.merchant_id)
    end
  end

  describe 'Sad Path' do
    it 'returns 404 with invalid id' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      invalid = item.id + 1

      get "/api/v1/items/#{invalid}"

      expect(response).to have_http_status(404)
    end
  end
end
