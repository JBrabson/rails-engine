require 'rails_helper'
RSpec.describe 'Item Delete API' do
  before :each do
    FactoryBot.reload
  end

  describe 'Happy Path' do
    it 'can delete item' do
      items = create_list(:item, 2)
      item1_id = items.first.id

      delete "/api/v1/items/#{item1_id}"
      expect(response).to have_http_status(204)
      expect(response.body).to eq("")

      expect(Item.count).to eq(1)
      expect(Item.first.id).to_not eq(item1_id)
    end

    # it 'can delete invoices associated with item' do
    #   customer = create(:customer)
    #   merchant = create(:merchant)
    #   transaction = create(:transaction)
    #   invoice_item = create(:invoice_item)
    #   item = create(:item)
    #
    #   delete "/api/v1/items/#{item.id}"
    #   expect(item.invoices).to eq([])
    # end
    #
    # it 'will only delete invoices associated with item, if no other items are listed on invoice' do
    #   customer = create(:customer)
    #   merchant = create(:merchant)
    #   item = create(:item, merchant_id: merchant.id)
    #   item2 = create(:item, merchant_id: merchant.id)
    #   invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id, status: "shipped")
    #   invoice_item = InvoiceItem.create(:invoice_item, item_id: item, invoice_id: invoice)
    #   invoice_item2 = InvoiceItem.create(:invoice_item, item_id: item2, invoice_id: invoice)
    #   transaction = create(:transaction, invoice_id: invoice.id, result: "success")
    #   delete "/api/v1/items/#{item.id}"
    #   expect(item.invoices).to eq([invoice])
    # end
  end

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
