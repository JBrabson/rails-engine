class Api::V1::MerchantsController < ApplicationController
  def index
    if (params[:per_page]).to_i >= 200
      merchants = Merchant.all
    else
      merchants = Merchant.pagination(params.fetch(:per_page, 20).to_i, params.fetch(:page, 1).to_i)
    end
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end
end
