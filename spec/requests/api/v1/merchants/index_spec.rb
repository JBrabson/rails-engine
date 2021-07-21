require 'rails_helper'
RSpec.describe 'Merchants API' do
  before :each do
    FactoryBot.reload
  end

  describe 'Happy Path' do
    it 'returns list of all merchants, with default of 20 per page' do
      create_list(:merchant, 50)
      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(Merchant.all.count).to eq(50)
      expect(merchants[:data].count).to eq(20)
      expect(merchants[:data].first[:id]).to eq('1')
      expect(merchants[:data].last[:id]).to eq('20')

      merchants[:data].each do |merchant|
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
      create_list(:merchant, 35)
      merchants = Merchant.all

      get '/api/v1/merchants'
      merchants_json = JSON.parse(response.body, symbolize_names: true)

      expect(merchants_json[:data].count).to eq(20)
      expect(merchants_json[:data].first[:id]).to eq(merchants.first.id.to_s)
      expect(merchants_json[:data].last[:id]).to eq(merchants.last.id.to_s)
    end

    it 'returns unique list on each page' do
      create_list(:merchant, 50)
      get '/api/v1/merchants'
      merchants1 = JSON.parse(response.body, symbolize_names: true)

      get '/api/v1/merchants?page=2'
      merchants2 = JSON.parse(response.body, symbolize_names: true)

      expect(merchants1).to_not eq(merchants2)
    end

    it 'allows user to choose per_page value and page' do
      per_page = 25
      page = 2
      create_list(:merchant, 50)
      get "/api/v1/merchants?per_page=#{per_page}&page=#{page}"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(Merchant.all.count).to eq(50)
      expect(merchants[:data].count).to eq(25)
      expect(merchants[:data].first[:id]).to eq('26')
      expect(merchants[:data].last[:id]).to eq('50')
    end
  #TODO edgecase for incorrect inputs

    it 'fetch second page of 20 merchants, containing no data, to return empty array' do
      create_list(:merchant, 20)
      get '/api/v1/merchants?page=2'

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(Merchant.all.count).to eq(20)
      expect(merchants[:data]).to eq([])
    end

    it 'fetch all merchants if per_page count is high' do
      create_list(:merchant, 201)
      get '/api/v1/merchants?per_page=200'

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(201)
    end
  end

  describe 'Sad Path' do
    it 'fetching page 1 if page selected is 0 or lower' do
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
