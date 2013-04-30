require 'feature_spec_helper'

describe "As an logged in Administrator of a store" do
  context "and I am in the admin dashboard" do
    # before(:each) do
    #  admin = FactoryGirl.create(:user)
    #  @store = FactoryGirl.create(:store)
    #  @category = FactoryGirl.create(:category, store_id: @store)
    #  Role.promote(admin, @store, 'admin')
    #  visit login_path
    #  fill_in 'sessions_email', with: 'brad@example.com'
    #  fill_in 'sessions_password', with: 'password'
    #  click_button 'Login'
    # end
    
    # it "has a link to the promotion dashboard page" do
    #  visit store_admin_manage_path(@store)
    #  page.should have_content "Categories"
    # end
    
    # it "when i click Categories, I should see a new category promo button" do
    #  visit store_admin_manage_path(@store)
    #  click_link "New Category Promotion"
    #  page.should have_content("Promotion Title")
    # end
    
    # it "I am able to set up a promotion for a product" do
    #  pending
    #  visit store_admin_promotions_path(@store)
    #  click_button "Promote Product"
    #  page.should have_content("Product Promotion Form")
    # end

    it 'allows me to create a new promotion for a category', js: true do
      admin = FactoryGirl.create(:random_user)
      @store = FactoryGirl.create(:random_store)
      @category = FactoryGirl.create(:random_category, store_id: @store.id)
      Role.promote(admin, @store, 'admin')

      visit login_path
      fill_in 'sessions_email', with: admin.email
      fill_in 'sessions_password', with: 'password'
      click_button 'Login'
      visit store_admin_manage_path(@store)

      click_link "Categories"
      click_link "-Edit"

      click_link "New Category Promotion"

      page.should have_content("Promotion Title")

      fill_in :promotion, with: 10.0
      
      click_button "Submit"

      visit store_home_path(@store)

      click_link "Select a Category"
    end
  end
end
