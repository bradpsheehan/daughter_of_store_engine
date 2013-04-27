class Admin::PromotionsController < ApplicationController
  before_filter :require_admin

  def index
    # @promotions = current_store.promotions.order('created_at DESC')
    #                          .page(params[:page]).per(20)
  end

  def new
    # @promotion = Promotion.new
  end

  def create
    # @promotion = current_store.promotions.build(params[:promotion])
    # if @promotion.save
    #   redirect_to store_admin_promotions_path,
    #   :notice => "Successfully created promotion."
    # else
    #   render :action => 'new'
    # end
  end

  def edit
    # @promotion = current_store.promotions.find(params[:id])
  end

  def update
    # @promotion = current_store.promotions.find(params[:id])
    # if @promotion.update_attributes(params[:promotion])
    #   redirect_to store_admin_promotions_path,
    #   :notice  => "Successfully updated promotion."
    # else
    #   render :action => 'edit'
    # end
  end
end
