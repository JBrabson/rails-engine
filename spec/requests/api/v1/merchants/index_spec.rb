require 'rails_helper'
RSpec.describe 'Merchants API' do
  before :each do
    FactoryBot.reload
    Merchant.destroy_all
  end

  describe 'Happy Path' do
    it 'returns list of all merchants, with default of 20 per page' do
      36.times do |index|
        Merchant.create!(name: "Merchant-#{index + 1}")
      end

      get '/api/v1/merchants'

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchants.count).to eq(20)
      expect(merchants.first[:attributes][:name]).to eq("Merchant-1")
      expect(merchants.last[:attributes][:name]).to eq("Merchant-20")

      get '/api/v1/merchants?page=2'
      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchants.count).to eq(16)

      merchants.each do |merchant|
        expect(merchant).to be_a(Hash)
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_a(String)
        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a(Hash)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it 'first page of 20 matches first 20 in database' do
      36.times do |index|
        Merchant.create!(name: "Merchant-#{index + 1}")
      end

      get '/api/v1/merchants?page=1'

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchants.count).to eq(20)
      expect(merchants.first[:attributes][:name]).to eq("Merchant-1")
      expect(merchants.last[:attributes][:name]).to eq("Merchant-20")
    end

    it 'returns unique list or merchants on each page' do
      create_list(:merchant, 50)

      get '/api/v1/merchants'
      merchants1 = JSON.parse(response.body, symbolize_names: true)

      get '/api/v1/merchants?page=2'
      merchants2 = JSON.parse(response.body, symbolize_names: true)

      expect(merchants1).to_not eq(merchants2)
    end

    it 'allows user to choose per_page value and page' do
      create_list(:merchant, 50)
      per_page = 25
      page = 2

      get "/api/v1/merchants?per_page=#{per_page}&page=#{page}"

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(Merchant.all.count).to eq(50)
      expect(merchants[:data].count).to eq(25)
      expect(merchants[:data].first[:id]).to eq('26')
      expect(merchants[:data].last[:id]).to eq('50')
    end

    it 'returns empty array for page containing no merchants' do
      create_list(:merchant, 20)

      get '/api/v1/merchants?page=2'

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(Merchant.all.count).to eq(20)
      expect(merchants[:data]).to eq([])
    end

    it 'returns all merchants if per_page count is high' do
      create_list(:merchant, 201)

      get '/api/v1/merchants?per_page=200'

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(201)
    end
  end

  describe 'Sad Path' do
    it 'returns page 1 if page selected is 0 or lower' do
      create_list(:merchant, 50)

      get '/api/v1/merchants?page=1'
      page1 = JSON.parse(response.body, symbolize_names: true)

      get '/api/v1/merchants?page=0'
      page0 = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(page1[:data].count).to eq(20)
      expect(page1).to eq(page0)
    end
  end
end
