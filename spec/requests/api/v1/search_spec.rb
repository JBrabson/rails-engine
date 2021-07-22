require 'rails_helper'
RSpec.describe 'Merchants Search API' do
  before :each do
    FactoryBot.reload
  end

  describe 'Happy Path' do
    it 'returns merchant matching search term' do
      finn = create(:merchant, name: 'Finneas Smitherton')
      search_term = 'fin'

      get "/api/v1/merchants/find?name_search=#{search_term}"
      # expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)
      expect(merchant.count).to eq(1)
      expect(merchant).to be_a Hash
      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to eq(finn.id.to_s)
      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to eq("merchant")
      expect(merchant[:data]).to have_key(:attributes)
      expect(merchant[:data][:attributes]).to be_a(Hash)
      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to eq(finn.name)
    end

    it 'returns first alphabetical match if more than one found' do
      huck = create(:merchant, name: 'Huckleberry Finn')
      finn = create(:merchant, name: 'Finneas Smitherton')
      fast = create(:merchant, name: 'Fast Fins')
      search_term = 'fin'

      get "/api/v1/merchants/find?name_search=#{search_term}"
      # expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)
      expect(merchant.count).to eq(1)
      expect(merchant[:data][:attributes][:name]).to eq(fast.name)
    end

    it 'is not case sensitive' do
      huck = create(:merchant, name: 'Huckleberry Finn')
      finn = create(:merchant, name: 'Finneas Smitherton')
      fast = create(:merchant, name: 'Fast Fins')
      search_term = 'fIn'

      get "/api/v1/merchants/find?name_search=#{search_term}"
      # expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)
      expect(merchant.count).to eq(1)
      expect(merchant[:data][:attributes][:name]).to eq(fast.name)
    end
  end

  describe 'Sad Path' do
    it '' do

    end
  end
end
