require 'rails_helper'
RSpec.describe 'Items API' do
  before :each do
    FactoryBot.reload
  end

  describe 'Happy Path' do
    it 'returns list of all items, with default of 20 per page' do
      create_list(:merchant, 7)
      create_list(:item, 36)
      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      expect(Item.all.count).to eq(36)
      expect(items[:data].count).to eq(20)
      expect(items[:data].first[:id]).to eq('1')
      expect(items[:data].last[:id]).to eq('20')

      items[:data].each do |item|
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
      merchant = create(:merchant)
      80.times do |index|
        Item.create!(name: "Item-#{index + 1}", description: Faker::GreekPhilosophers.quote, unit_price: Faker::Commerce.price, merchant: merchant)
      end
      get '/api/v1/items?page=1'
      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(items.count).to eq(20)
      expect(items.first[:attributes][:name]).to eq("Item-1")
      expect(items.last[:attributes][:name]).to eq("Item-20")
      # create_list(:merchant, 2)
      # create_list(:item, 35)
      # items = Item.all
      #
      # get '/api/v1/items'
      # items_json = JSON.parse(response.body, symbolize_names: true)
      #
      # expect(items_json[:data].count).to eq(20)
      # expect(items_json[:data].first[:id]).to eq(items.first.id.to_s)
      # expect(items_json[:data].last[:id]).to eq(items.last.id.to_s)
    end

    it 'returns unique list on each page' do
      create_list(:merchant, 7)
      create_list(:item, 40)
      get '/api/v1/items'
      items_pg1 = JSON.parse(response.body, symbolize_names: true)

      get '/api/v1/items?page=2'
      items_pg2 = JSON.parse(response.body, symbolize_names: true)

      expect(items_pg1).to_not eq(items_pg2)
    end

    it 'allows user to choose per_page value and page' do
      per_page = 25
      page = 2
      create_list(:item, 50)
      get "/api/v1/items?per_page=#{per_page}&page=#{page}"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      expect(Item.all.count).to eq(50)
      expect(items[:data].count).to eq(25)
      expect(items[:data].first[:id]).to eq('26')
      expect(items[:data].last[:id]).to eq('50')
    end


    it 'fetch second page of 20 items, containing no data, to return empty array' do
      create_list(:item, 20)
      get '/api/v1/items?page=2'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(Item.all.count).to eq(20)
      expect(items[:data]).to eq([])
    end

    it 'fetch all items if per_page count is high' do
      create_list(:item, 201)
      get '/api/v1/items?per_page=200'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(201)
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
