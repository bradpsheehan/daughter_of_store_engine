class Admin::CategoriesController < ApplicationController
  before_filter :require_admin

  def index
    @categories = current_store.categories.order('created_at DESC')
                             .page(params[:page]).per(20)
  end

  def new
    @category = Category.new
  end

  def create
    promo = params[:category].delete(:promotion)
    @category = current_store.categories.build(params[:category])
    if @category.save
      @category.promotion = promo
      @category.save
      redirect_to store_admin_categories_path,
        :notice => "Successfully created category."
    else
      render :action => 'new', :notice  => "Category creation failed."
    end
  end

  def edit
    @category = current_store.categories.find(params[:id])
  end

  def update
    promo = params[:category].delete(:promotion)
    @category = current_store.categories.find(params[:id])
    if @category.update_attributes(params[:category])
      @category.promotion = promo
      @category.save
      redirect_to store_admin_categories_path,
      :notice  => "Successfully updated category."
    else
      render :action => 'edit', :notice  => "Update failed."
    end
  end
end
