class Api::V1::ItemsController < ApplicationController
  def index
    if (params[:per_page]).to_i >= 200
      items = Item.all
    else
      items = Item.pagination(params.fetch(:per_page, 20).to_i, params.fetch(:page, 1).to_i)
    end
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def new
  end

  def create
    item = Item.create(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    end
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    if item.save
      render json: ItemSerializer.new(item)
    else
      render json: {data: {}}, status: 400
    end
  end

  def destroy
    item = Item.find(params[:id])
    invoices = item.invoices

    invoices.map do |invoice|
      invoice.items.count = 1
      invoice.destroy
    end

    item.destroy
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
