require 'spec_helper'

describe Admin::OrdersController do
   let(:user) {FactoryGirl.create(:uber)}
   let(:store) {FactoryGirl.create(:store)}
   let!(:order) {FactoryGirl.create(:order, store: store, user: user)}
 before do
    controller.stub(:require_admin => true)
    controller.stub(:current_user => user)
    controller.stub(:current_store => store)
 end

  it "index action should return a collection of orders" do
    get :index
    expect(assigns(:orders)).to match_array [order]
  end

  it "show action should return an individual order" do
    get :show, id: order.id
    expect(assigns(:order)).to eq order
  end

  describe 'update' do
    it 'works correctly' do
      request.env["HTTP_REFERER"] = '/'
      post :update, id: order.id, update_status: 'pending'
      expect(order.status).to eq 'pending'
    end
  end
end
