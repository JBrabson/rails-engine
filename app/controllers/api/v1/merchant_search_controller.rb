class Api::V1::MerchantSearchController < ApplicationController

  def index
  end

  def show
    merchant = Merchant.find_by_name(params[:name_search])

    if merchant.nil?
      render json: {data: {}, errors: ['No Matches for Your Search']}, status: :not_found
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end
