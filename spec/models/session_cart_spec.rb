require 'spec_helper'

describe 'SessionCart' do
  let!(:store){FactoryGirl.create(:store)}
  let!(:product){FactoryGirl.create(:product, store_id: store.id)}

  it '.new' do
    @cart = {store.id => {product.id => 1}}
    @session_cart = SessionCart.new(@cart,store)
    expect(@session_cart).to be_kind_of SessionCart
  end

  it '#count' do
    @cart = {store.id => {product.id => 1}}
    @session_cart = SessionCart.new(@cart,store)
    expect(@session_cart.count).to eq "(1)"
  end

  it '#empty?' do
    @cart = {store.id => {product.id => 1}}
    @session_cart = SessionCart.new(@cart,store)
    expect(@session_cart.empty?).to eq false
    @session_cart.remove_item(product.id)
    expect(@session_cart.empty?).to eq true
  end

  it '#each(&block)' do
    @cart_hash = {store.id => {product.id => 1}}
    @session_cart = SessionCart.new(@cart_hash,store)
    @session_cart.each do |cart_item|
      expect(cart_item.quantity).to eq 1
    end
  end

  it '#remove_item(product)' do
    @cart = {store.id => {product.id => 1}}
    @session_cart = SessionCart.new(@cart,store)
    @session_cart.remove_item(product.id)
    expect(@session_cart.count).to eq nil
  end

  it '#update(cart_data)' do
    @cart = {store.id => {product.id => 5}}
    @session_cart = SessionCart.new(@cart,store)
    @session_cart.update({:product_id => product.id, :quantity => 3})
    expect(@session_cart.count).to eq '(3)'
  end

  it "#destroy" do
    @cart = {store.id => {product.id => 5}}
    @session_cart = SessionCart.new(@cart,store)
    @session_cart.destroy
    @session_cart.each do |cart_item|
      expect(cart_item.cart_data).to eq nil
    end
  end
end
