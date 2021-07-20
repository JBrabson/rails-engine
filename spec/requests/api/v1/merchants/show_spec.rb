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
