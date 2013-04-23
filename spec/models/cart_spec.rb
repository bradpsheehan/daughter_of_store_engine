require 'spec_helper'

describe Cart do
  context 'cart' do
    before(:each) do
      @store = FactoryGirl.create(:store)
      @product = FactoryGirl.create(:product, store_id:@store.id)
      @session = {}
      @session[:cart] = {@product.id => '2'}
    end

    it 'has items' do
      cart = Cart.new(@session[:cart])
      expect(cart.cart_data).to eq ({@product.id => '2'})
    end

    it 'can #items' do
      cart = Cart.new(@session[:cart])
      expect(cart.items.count).to eq 1
      expect(cart.items.first.quantity).to eq '2'
    end

    it 'can #total' do
      cart = Cart.new(@session[:cart])
      expect(cart.total.truncate).to eq 25
    end

    it 'can #remove_item(product_id)' do
      cart = Cart.new(@session[:cart])
      expect(cart.total.truncate).to eq 25
      cart.remove_item(@product.id)
      expect(cart.total).to eq nil
    end

    #needs work
    it 'can update(carts_param)' do
      cart = Cart.new(@session[:cart])
      @session[:cart][@product.id].should ==  2.to_s
      @session[:cart][@product.id] = 3
      cart.update(@session[:cart])
      @session[:cart][@product.id].should ==  3
      cart.total.truncate.should >= 25
      @session[:cart][:quantity] = 4
      cart.update(@session[:cart])
    end

    it 'can #destroy' do
      cart = Cart.new(@session[:cart])
      @session[:cart][@product.id].should ==  2.to_s
      cart.items.count.should >= 1
      cart.destroy
      cart.items.count.should == 0
    end

    it 'can #count' do
      cart = Cart.new(@session[:cart])
      expect(cart.count).to eq "(2)"
      cart.destroy
      expect(cart.count).to eq nil
    end
  end
end
