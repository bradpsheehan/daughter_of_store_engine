class CartsController < ApplicationController
  def show
    @discount ||= Discount.new
    if params[:discounts]
      store = Store.find_by_path(params[:store_path])
      @discount = Discount.find_by_name_and_store_id(params[:discounts][:name],store.id)
      if @discount && @discount.percent
        session[:discount] = @discount.amount / 100
        flash[:notice] = "Percentage Discount Applied"
      elsif @discount
        session[:discount] = @discount.amount
        flash[:notice] = "Oh Yeah! You just got some dollars off!"
      else
        redirect_to store_cart_path(current_store), :notice  => "Discount doesn't exist"
      end
    end
  end

  def update
    current_cart.update params[:carts]
    redirect_to(:back)
  end

  def remove_item
    current_cart.remove_item params[:product_id]
    redirect_to(:back)
  end

  def destroy
    current_cart.destroy
    redirect_to store_home_path(current_store), :notice  => "Cart cleared."
  end
end
