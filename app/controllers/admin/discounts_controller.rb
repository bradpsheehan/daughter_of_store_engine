class Admin::DiscountsController < ApplicationController

  def index
    @discounts = Discount.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @discounts }
    end
  end

  def show
    @discount = Discount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @discount }
    end
  end

  def new
    @discount = Discount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @discount }
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def create
    @discount = Discount.new(params[:discount])

    respond_to do |format|
      if @discount.save
        format.html { redirect_to store_admin_discounts_path(current_store), notice: 'Discount was successfully created.' }
        format.json { render json: @discount, status: :created, location: @discount }
      else
        format.html { render action: "new" }
        format.json { render json: @discount.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @discount = Discount.find(params[:id])

    respond_to do |format|
      if @discount.update_attributes(params[:discount])
        format.html { redirect_to store_admin_discounts_path(current_store), notice: 'Discount was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @discount.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @discount = Discount.find(params[:id])
    @discount.destroy

    respond_to do |format|
      format.html { redirect_to store_admin_discounts_url }
      format.json { head :no_content }
    end
  end
end
