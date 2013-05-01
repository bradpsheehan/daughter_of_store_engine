class CartsController < ApplicationController

  class CartCalculator
    def initialize(cart,discount)
      @cart = cart
      @discount = discount
    end

    attr_reader :cart, :discount

    def sub_total
      cart.pretotal
    end

    def grand_total
      discount.apply(cart)
    end

    def savings
      sub_total - grand_total
    end

    def discount_applied?
      grand_total != sub_total
    end
  end

  def load_discount(discount_name)
    Discount.find_by_name_and_store_id(discount_name,current_store.id) || Discount.not_found
  end

  def discount_has_been_specified?
    params[:discounts]
  end

  def show
    @discount = Discount.not_found

    if discount_has_been_specified?
      @discount = load_discount(params[:discounts][:name])
      session[:discount_id] = @discount.discount_id
      flash[:notice] = @discount.message
    end

    @cart_calculator = CartCalculator.new(current_cart,@discount)

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
