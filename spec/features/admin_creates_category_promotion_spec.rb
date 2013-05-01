require 'feature_spec_helper'

describe "As an logged in Administrator of a store" do
  context "and I am in the admin dashboard" do


    it 'allows me to create a new promotion for a category' do
      admin = FactoryGirl.create(:random_user)
      @store = FactoryGirl.create(:random_store)
      @category = FactoryGirl.create(:random_category, store_id: @store.id)
      @product = FactoryGirl.create(:random_product, store_id: @store.id)
      @category.products << @product
      Role.promote(admin, @store, 'admin')

      visit login_path
      fill_in 'sessions_email', with: admin.email
      fill_in 'sessions_password', with: 'password'
      click_button 'Login'
      visit store_admin_manage_path(@store)

      click_link "Categories"
      click_link "Edit"

      page.should have_content("Promotion")

      fill_in :category_promotion, with: 10.0

      click_button "Submit"

      visit store_home_path(@store)

      find('.dropdown-toggle').click

      category_html_id = "#category-#{@category.title.gsub(/\s/,'-')}"

      find(category_html_id).click

      click_link "#{@product.title}"

      page.should have_content("Promo Price")
    end
  end
end
