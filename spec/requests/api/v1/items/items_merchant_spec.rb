require 'rails_helper'
RSpec.describe "Item's Merchant API" do
  before :each do
    FactoryBot.reload
  end

  describe 'Happy Path' do
    it "returns an item's merchant" do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get "/api/v1/items/#{item.id}/merchant"
      expect(response).to be_successful
      merchant = item.merchant
      merchant_json = JSON.parse(response.body, symbolize_names: true)
      expect(merchant_json[:data][:id].to_s).to eq(merchant.id.to_s)
    end
  end

#TODO
  # describe 'Sad Path' do
  #   it 'returns 404 if item not found' do
  #     expect(response).to have_http_status(404)
  #   end
  # end
end
