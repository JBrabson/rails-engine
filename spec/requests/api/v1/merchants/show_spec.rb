require 'rails_helper'
RSpec.describe 'Merchants Show API' do
  before :each do
    FactoryBot.reload
  end

  describe 'Happy Path' do
    it 'returns one merchant by id' do
      create_list(:merchant, 10)

      get '/api/v1/merchants/7'
      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)
      expect(merchant.count).to eq(1)
      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_a(String)
      expect(merchant[:data][:id]).to eq('7')
      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to be_a(String)
      expect(merchant[:data]).to have_key(:attributes)
      expect(merchant[:data][:attributes]).to be_a(Hash)
      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end
  end

  describe 'Sad Path' do
    it 'returns 404 with invalid id' do
      create_list(:merchant, 10)

      get '/api/v1/merchants/11'
      expect(response).to have_http_status(404)
    end
  end
end
