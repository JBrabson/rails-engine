require 'rails_helper'
RSpec.describe 'Merchant Items Index API' do
  before :each do
    FactoryBot.reload
  end

  describe 'Happy Path' do
    it 'returns all items that belong to merchant' do
      merchant = create(:merchant)
      items = create_list(:item, 7, merchant: merchant)

      get "/api/v1/merchants/#{merchant.id}/items"
      expect(response).to be_successful
      items = merchant.items
      items_json = JSON.parse(response.body, symbolize_names: true)
      expect(items.count).to eq(7)
      expect(items_json[:data].first[:id].to_s).to eq(items.first.id.to_s)
    end
  end

  # describe 'Sad Path' do
  #   it 'returns 404 with invalid id' do
  #     create_list(:merchant, 10)
  #
  #     get '/api/v1/merchants/11'
  #     expect(response).to have_http_status(404)
  #   end
  # end
end
