require 'spec_helper'

describe 'As a user viewing the products of a store' do
  before(:each) do
    @store = FactoryGirl.create(:store)
    @product = FactoryGirl.create(:product, store_id: @store.id, promotion: 87.96)
  end
  context 'and the user sees a product on sale' do
    it 'can buy it at the promotional price', js: true do
      visit store_home_path(@store)
      click_link "#{@product.title}"
      page.should have_content "Promo Price"
      click_button 'Add to Cart'
      visit store_cart_path(@store)
      # click_button "Cart (1)"   ?
      click_link 'Checkout'
      click_link 'Continue'
      expect(page).to have_content("Shipping Address")

      Resque.stub(:enqueue)

      fill_in 'user_email', with: 'daniel@example.com'

      fill_in 'user_shipping_address_attributes_street', with: '1234 big walk way'
      fill_in 'user_shipping_address_attributes_city', with: 'Denver'
      fill_in 'user_shipping_address_attributes_state', with: 'CO'
      fill_in 'user_shipping_address_attributes_zipcode', with: '80210'

      fill_in 'user_billing_address_attributes_street', with: '1234 big walk way'
      fill_in 'user_billing_address_attributes_city', with: 'Denver'
      fill_in 'user_billing_address_attributes_state', with: 'CO'
      fill_in 'user_billing_address_attributes_zipcode', with: '80210'
      click_button 'Checkout'
      page.should have_content "$11.42"
    end
  end
end
