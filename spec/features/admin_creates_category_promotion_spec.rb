require 'spec_helper'

describe "As an logged in Administrator of a store" do 
  context "and I am in the admin dashboard" do 
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
    # it "has a link to the promotion dashboard page" do 
    #   visit store_admin_manage_path(@store)
    #   page.should have_content "Promotions"
    # end
    # it "when i click promotions, I should be at promos dashboard" do 
    #   visit store_admin_manage_path(@store)
    #   click_link "Promotions"
    #   page.should have_content("Promote Product")
    #   page.should have_content("Promote Category")
    #   page.should have_content("Promote Store")
    # end
    # it "I am able to set up a promotion for a product" do 
    #   visit store_admin_promotions_path(@store)
    #   click_button "Promote Product"
    #   page.should have_content("Product Promotion Form")
    # end
  end
end