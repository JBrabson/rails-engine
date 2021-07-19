class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.pagination(params.fetch(:per_page, 20).to_i, params.fetch(:page, 1).to_i)
    render json: MerchantSerializer.new(merchants)
  end
end
