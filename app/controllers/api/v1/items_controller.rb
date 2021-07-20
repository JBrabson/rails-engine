class Api::V1::ItemsController < ApplicationController
  def index
      items = Item.pagination(params.fetch(:per_page, 20).to_i, params.fetch(:page, 1).to_i)
      render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end
end
