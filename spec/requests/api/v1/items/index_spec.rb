require 'rails_helper'
RSpec.describe 'Items API' do
  before :each do
    FactoryBot.reload
  end

  describe 'Happy Path' do
    it 'returns list of all items, 20 per page' do
      create_list(:merchant, 7)
      create_list(:item, 36)

      get '/api/v1/items'
      items_pg1 = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(items_pg1[:data].count).to eq(20)

      items_pg1[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end

      get '/api/v1/items?page=2'
      items_pg2 = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(items_pg2[:data].count).to eq(16)

      items_pg2[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
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

    it 'first page of 20 matches first 20 in database' do
      create_list(:merchant, 2)
      create_list(:item, 30)

      get '/api/v1/items?page=1'
      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data].count).to eq(20)
      expect(items[:data].first[:id]).to eq("1")
      expect(items[:data].last[:id]).to eq("20")
    end

    it 'second page of 20 matches 21-40 in database' do
      create_list(:merchant, 2)
      create_list(:item, 45)

      get '/api/v1/items?page=2'
      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data].count).to eq(20)
      expect(items[:data].first[:id]).to eq("21")
      expect(items[:data].last[:id]).to eq("40")
    end
  end

  describe 'Sad Path' do
    it 'fetching page 1 if page is 0 or lower' do
      create_list(:merchant, 2)
      create_list(:item, 30)

      get '/api/v1/items?page=1'
      page1 = JSON.parse(response.body, symbolize_names: true)

      get '/api/v1/items?page=0'
      page0 = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(page1[:data].count).to eq(20)

      expect(page1).to eq(page0)
    end
  end
end
