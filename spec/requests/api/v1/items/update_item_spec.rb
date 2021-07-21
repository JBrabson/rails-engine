require 'rails_helper'
RSpec.describe 'Items Update API' do
  before :each do
    FactoryBot.reload
  end

  describe 'Happy Path' do
    it 'can update item' do
      merchant = create(:merchant)
      item = Item.create(name: 'Thing', description: 'That is a thing.', unit_price: 15.00, merchant_id: merchant.id)

      newer_params = {
        name: 'Newer Thing',
        description: 'That is a newer thing.',
        unit_price: 1500.00,
        merchant_id: merchant.id
      }

      patch "/api/v1/items/#{item.id}", params: newer_params
      expect(response).to have_http_status(200)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:description]).to eq(newer_params[:description])
    end

    it 'can update item with partial attribute update' do
      merchant = create(:merchant)
      item = Item.create(name: 'Thing', description: 'That is a thing.', unit_price: 15.00, merchant_id: merchant.id)

      newer_params = {
        name: 'Newer Thing',
        unit_price: 1500.00,
      }

      patch "/api/v1/items/#{item.id}", params: newer_params
      expect(response).to have_http_status(200)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:name]).to eq(newer_params[:name])
      expect(json[:data][:attributes][:description]).to eq(item[:description])
      expect(json[:data][:attributes][:unit_price]).to eq(newer_params[:unit_price])
      expect(json[:data][:attributes][:merchant_id]).to eq(item[:merchant_id])
    end
  end
    # TEST FOR UDPATING LESS THAN ALL ATTRIBUTES




  #
  #
  #
  #
  #   # it 'can delete item' do
  #   # end
  # end
  #
  # describe 'Sad Path' do
  #   it 'returns error if attribute is missing' do
  #     merchant = create(:merchant)
  #     # items = create(:item)
  #     # expect(Item.count).to eq(1)
  #
  #     item_params = {
  #       name: 'New Item',
  #       description: 'Shiny & New',
  #       unit_price: '',
  #       merchant_id: merchant.id
  #     }
  #
  #     expect(Item.count).to eq(0)
  #     post "/api/v1/items", params: item_params
  #     expect(response).to have_http_status(204)
  #     #TODO error specifically 400 or 204 valid?
  #     expect(Item.count).to eq(0)
  #   end
  # end
end
