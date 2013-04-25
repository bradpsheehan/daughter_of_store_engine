class ProductsController < ApplicationController
  before_filter :require_current_store

  def index
    @current_store = Store.all_cached.find{|s| s.id == current_store.id}
    @products = @current_store.products.by_category(params[:category_id])
                             .active.page(params[:page]).per(20)
    @categories = current_store.categories
    session[:return_to] = request.fullpath
  end

  def show
    @store = current_store
    @product = @store.products.find(params[:id])
    session[:return_to] = request.fullpath
  end
end
