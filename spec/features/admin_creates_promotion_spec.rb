require 'spec_helper'

describe 'an admin can put a product on sale with a promotion' do
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

      it 'has a field for promotion on the product edit page' do
        visit store_home_path(@store)
        current_path.should eq store_home_path(@store)
        page.should have_link "Admin"
        click_link "Admin"
        current_path.should eq store_admin_manage_path(@store)
        page.should have_link "Products"
        visit store_admin_products_path(@store)
        click_link "Edit"
        current_path.should eq edit_store_admin_product_path(@store, @product)
        page.should have_field "amount"
      end

      context 'admin edits a products promotion field' do
        it 'succesfully updates the product' do
          visit edit_store_admin_product_path(@store, @product)
          fill_in "amount", with: 75
          click_button "Submit"
          expect(page).to have_content "Successfully updated product"
          visit store_product_path(@store, @product)
          expect(page).to have_content(3.25)
        end

        it 'displays the adjusted promotional price on the page', :js => true do
          visit edit_store_admin_product_path(@store, @product)
          fill_in "amount", with: 75
          current_path.should eq edit_store_admin_product_path(@store, @product)
          page.should have_content("Promotional Price: $3.25")
        end

        it 'triggers an alert when a non-number is entered, and does not update price', :js => true do
          visit edit_store_admin_product_path(@store, @product)
          fill_in "amount", with: 'a'
          page.driver.browser.switch_to.alert.accept
          page.should have_content("Promotional Price: $NaN")
          click_button "Submit"
          expect(page).to have_content "Successfully updated product"
          visit store_product_path(@store, @product)
          expect(page).to have_content(12.99)
        end

        it 'triggers an alert when a value greater than 100 is entered, and assigns product promo of 100%', :js => true do
          visit edit_store_admin_product_path(@store, @product)
          fill_in "amount", with: 200
          page.driver.browser.switch_to.alert.accept
          page.should have_content("Promotional Price: $0")
          click_button "Submit"
          expect(page).to have_content "Successfully updated product"
          visit store_product_path(@store, @product)
          expect(page).to have_content(0)
        end
      end
    end
  end
end
