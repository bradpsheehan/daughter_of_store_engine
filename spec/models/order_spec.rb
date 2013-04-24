require 'spec_helper'

describe Order do
  before(:each) do
    @user = FactoryGirl.create(:user)
    Order.destroy_all
  end

  let!(:order){FactoryGirl.create(:order, user: @user, status: 'pending')}
  let!(:order2){FactoryGirl.create(:order, user: @user, status: 'paid')}
  let!(:order3){FactoryGirl.create(:order, user: @user, status: 'paid')}
  let!(:order4){FactoryGirl.create(:order, user: @user, status: 'pending')}
  let!(:order5){FactoryGirl.create(:order, user: @user, status: 'pending')}

  it 'has a valid factory' do
    expect(FactoryGirl.build(:order, user: @user)).to be_valid
  end

  it 'is invalid without a user' do
    expect(FactoryGirl.build(:order, user: nil)).to_not be_valid
  end

  it 'is invalid without a valid status' do
    expect(FactoryGirl.build(:order, user: @user, status: 'pending')).to be_valid
    expect(FactoryGirl.build(:order, user: @user, status: 'cancelled')).to be_valid
    expect(FactoryGirl.build(:order, user: @user, status: 'paid')).to be_valid
    expect(FactoryGirl.build(:order, user: @user, status: 'shipped')).to be_valid
    expect(FactoryGirl.build(:order, user: @user, status: 'returned')).to be_valid
    expect(FactoryGirl.build(:order, user: @user, status: nil)).to_not be_valid
    expect(FactoryGirl.build(:order, user: @user, status: 'abracadabra')).to_not be_valid
  end

  context 'create_and_charge' 
#     it 'creates a new order' do
#       product = FactoryGirl.create(:product)

#       login_user @user
#       #create a cart for the user
#       session[:cart] = {product.id => '2'}
#       cart = Cart.new(session[:cart])
#       #user checks out the cart
#       order.create_and_charge(cart)
#       #that process creates a new order
    # end

  it '.by_status(status)' do
    expect(Order.by_status('paid').length).to eq 2
  end
end
