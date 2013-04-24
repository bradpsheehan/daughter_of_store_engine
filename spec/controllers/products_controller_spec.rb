require 'spec_helper'

describe ProductsController do
  describe 'GET #index' do
    it "index action should render index template" do
      # binding.pry
      store = FactoryGirl.create(:store)
      controller.stub(:current_store).and_return(store)
      get :index
      response.should render_template(:index)
    end
  end

  describe 'GET #show' do
    it "show actions should render show template" do
      store = FactoryGirl.create(:store)
      product = FactoryGirl.create(:product, store_id: store.id)
      controller.stub(:current_store).and_return(store)
      get :show, :id => product.id
      response.should render_template(:show)
    end
  end
end
