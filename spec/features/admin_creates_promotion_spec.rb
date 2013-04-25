require 'spec_helper'

describe 'an admin can choose products to put on sale for their store' do
  context 'a registered admin exists' do
    context 'and they are logged in' do
      before(:each) do
        admin = FactoryGirl.create(:user)
        @store = FactoryGirl.create(:store)
        @product = FactoryGirl.create(:product, store: @store)
        Role.promote(admin, @store, 'admin')
        visit login_path
        fill_in 'sessions_email', with: 'brad@example.com'
        fill_in 'sessions_password', with: 'password'
        click_button 'Login'
      end

      it 'admin visits the store' do
        visit store_home_path(@store)
        current_path.should eq store_home_path(@store)
        page.should have_link "Admin"
        click_link "Admin"
        current_path.should eq store_admin_manage_path(@store)
        page.should have_link "Products"
        visit store_admin_products_path(@store)
        click_link "Edit"
        current_path.should eq edit_store_admin_product_path(@store, @product)
        page.should have_field "Promotion"
      end

      context 'admin edits a products promotion field' do
        it 'succesfully updates the product' do
          visit edit_store_admin_product_path(@store, @product)
          fill_in "Promotion", with: 75
          click_button "Submit"
          expect(page).to have_content "Successfully updated product"
          visit store_product_path(@store, @product)
          expect(page).to have_content(3.25)
        end
      end
    end
  end
end
