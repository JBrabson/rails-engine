require 'rails_helper'
RSpec.describe 'Merchants API' do
  before :each do
    FactoryBot.reload
  end

  describe 'Happy Path' do
    it 'returns list of merchants, 20 at a time' do
      create_list(:merchant, 50)

      get '/api/v1/merchants'
      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(merchants[:data].count).to eq(20)
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

    it 'fetch first page of 50 merchants' do
      create_list(:merchant, 50)

      get '/api/v1/merchants?per_page=50&page=1'
      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(merchants[:data].count).to eq(50)
    end

    it 'fetch second page of 20 merchants' do
      create_list(:merchant, 50)

      get '/api/v1/merchants?per_page=20&page=2'
      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(merchants[:data].count).to eq(20)
    end
  end

  describe 'Sad Path' do
    it 'fetching page 1 if page is 0 or lower' do
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
