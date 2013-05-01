require 'spec_helper'

describe OrdersController do
  describe 'index' do
    context 'when the user is logged in' do
      context 'when the user has orders in their history' do
        it 'renders the index view' do
          user1 = FactoryGirl.create(:user)
          login_user user1
          expect(response).to be_success
        end

        it 'assigns the user variable' do
          user = FactoryGirl.create(:user)
          login_user user
          get :index
          assigns(user).should eq @user
        end

        it 'assigns order variables' do
          user = FactoryGirl.create(:user)
          login_user user
          orders = Order.create(user_id: user.id, status:"pending")
          get :index
          assigns(orders).should eq @orders
        end
      end
    end

    context 'when the user is NOT logged in' do
      it 'redirects them to the log in page' do
        get :index
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'show' do
    context 'when the user is logged in' do
      it 'assigns the order variable' do
        user = FactoryGirl.create(:user)
        store = FactoryGirl.create(:store)
        order = FactoryGirl.create(:order, user: user)
        login_user user
        get :show, params = {guid: order.guid}
        assigns(order).should eq @order
      end
    end
  end
end
