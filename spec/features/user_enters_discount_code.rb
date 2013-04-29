require 'spec_helper'

describe 'a user can enter a discount code while viewing cart' do
  context 'an anonymous user is viewing their cart' do
    before(:each) do
      @store = FactoryGirl.create(:store)
      product = FactoryGirl.create(:product, store_id: @store.id)
      visit store_home_path(@store)
      click_link "Itchy Sweater"
      click_button "Add to Cart"
      visit store_cart_path(@store)
    end

    it "can enter a discount code" do
      page.should have_button "Apply"
      page.should have_field 'discounts_discount'
      fill_in 'discounts_discount', :with => 'ABC123'
      page.should have_button "Apply"
    end
  end
end
