require 'spec_helper'

describe 'an admin can choose products to put on sale for their store' do
  context 'a registered admin exists' do
    context 'and they are logged in' do
      before(:each) do
        admin = FactoryGirl.create(:user)
        @store = FactoryGirl.create(:store)
        Role.promote(admin, @store, 'admin')
        visit login_path
        fill_in 'sessions_email', with: 'brad@example.com'
        fill_in 'sessions_password', with: 'password'
        click_button 'Login'
      end

      it "can navigate to the discount index page" do
        visit store_home_path(@store)
        current_path.should eq store_home_path(@store)
        page.should have_link "Admin"
        click_link "Admin"
        current_path.should eq store_admin_manage_path(@store)
        page.should have_link "Discounts"
        click_link "Discounts"
        current_path.should eq store_admin_discounts_path(@store)
      end

      it "navigate to the new discount page" do
        visit store_home_path(@store)
        current_path.should eq store_home_path(@store)
        page.should have_link "Admin"
        click_link "Admin"
        current_path.should eq store_admin_manage_path(@store)
        page.should have_link "Discounts"
        click_link "Discounts"
        current_path.should eq store_admin_discounts_path(@store)
        click_link "New Discount"
        current_path.should eq new_store_admin_discount_path(@store)
        page.should have_button "Create Code"
      end

      it "can create an new discount" do
        visit store_home_path(@store)
        current_path.should eq store_home_path(@store)
        page.should have_link "Admin"
        click_link "Admin"
        current_path.should eq store_admin_manage_path(@store)
        page.should have_link "Discounts"
        click_link "Discounts"
        current_path.should eq store_admin_discounts_path(@store)
        click_link "New Discount"
        current_path.should eq new_store_admin_discount_path(@store)
        page.should have_button "Create Code"
        fill_in "discount_name", :with => 'Spring Fever'
        fill_in "discount_amount", :with => 50
        click_button "Create Code"
        current_path.should eq store_admin_discounts_path(@store)
        page.should have_selector('h1', text: 'Discounts')
        page.should have_content "Spring Fever"
      end

      it "can create a new dollar amount discount" do
        discount = FactoryGirl.create(:discount)
        visit new_store_admin_discount_path(@store)
        page.should have_content "$"
        page.should have_content "%"
        click_button $
      end

      it "can creat a new percentage discount"  do
        
      end

    end
  end
end
