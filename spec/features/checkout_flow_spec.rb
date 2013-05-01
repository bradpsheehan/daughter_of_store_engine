require 'spec_helper'

describe 'Checkout flow' do
  context 'as an anonymous user' do
    before(:each) do
      @store = FactoryGirl.create(:store)
      @product = FactoryGirl.create(:product, store: @store)
    end
    it 'offers three options upon clicking checkout' do
      visit store_home_path(@store)
      click_link "#{@product.title}"
      click_button "Add to Cart"
      click_button "Cart (1)"
      click_link "Checkout"
      page.should have_content 'Login'
      page.should have_content 'Continue'
      page.should have_content 'Create a New Account'
    end

    context 'presented with the three options' do
      it 'selecting login will send to login and redirect with cart intact' do
        user = FactoryGirl.create(:user)
        visit store_home_path(@store)
        click_link "#{@product.title}"
        click_button "Add to Cart"
        click_button "Cart (1)"
        click_link "Checkout"
        fill_in 'sessions_email', with: 'brad@example.com'
        fill_in 'sessions_password', with: 'password'
        click_button "Login"
        page.should have_button "Cart (1)"
      end

      it 'selecting signup will send to signup and redirect with cart intact' do
        visit store_home_path(@store)
        click_link "#{@product.title}"
        click_button "Add to Cart"
        click_button "Cart (1)"
        click_link "Checkout"
        click_link "Create a New Account"
        fill_in "user_full_name", with: 'hat'
        fill_in "user_email", with: 'hat@hat.com'
        fill_in "user_display_name", with: 'hat'
        fill_in "user_password", with: 'password'
        fill_in "user_password_confirmation", with: 'password'

        Resque.stub(:enqueue)

        click_button "Submit"
        page.should have_button "Cart (1)"
      end

      it 'selecting anonymous checkout will prompt checkout page' do
        visit store_home_path(@store)
        click_link "#{@product.title}"
        click_button "Add to Cart"
        click_button "Cart (1)"
        click_link "Checkout"
        click_link "Continue"
        page.should have_button "Checkout"
      end
    end
  end

  context 'as an authenticated user' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @store = FactoryGirl.create(:store)
      @product = FactoryGirl.create(:product, :store => @store)
      visit login_path
      fill_in 'sessions_email', with: 'brad@example.com'
      fill_in 'sessions_password', with: 'password'
      click_button 'Login'
      visit store_home_path(@store)
    end
    it "will direct user to the checkout page" do
      click_link "#{@product.title}"
      click_button "Add to Cart"
      click_button "Cart (1)"
      click_link "Checkout"
      page.should have_button "Checkout"
    end

    context 'on the checkout page' do
      before(:each) do 
        click_link "#{@product.title}"
        click_button "Add to Cart"
        click_button "Cart (1)"
        click_link "Checkout"

        fill_in 'user_shipping_address_attributes_street', with: '1234 big walk way'
        fill_in 'user_shipping_address_attributes_city', with: 'Denver'
        fill_in 'user_shipping_address_attributes_state', with: 'CO'
        fill_in 'user_shipping_address_attributes_zipcode', with: '80210'

        fill_in 'user_billing_address_attributes_street', with: '1234 big walk way'
        fill_in 'user_billing_address_attributes_city', with: 'Denver'
        fill_in 'user_billing_address_attributes_state', with: 'CO'
        fill_in 'user_billing_address_attributes_zipcode', with: '80210'
        click_button 'Checkout'

        visit store_home_path(@store)
        click_link "#{@product.title}"
        click_button "Add to Cart"
        click_button "Cart (2)"
        click_link "Checkout"
      end

      it 'will present saved addresses' do
        find_field("user_shipping_address_attributes_street").value.should eq "1234 big walk way"
        find_field("user_shipping_address_attributes_city").value.should eq "Denver"
        find_field("user_shipping_address_attributes_state").value.should eq "CO"
        find_field("user_shipping_address_attributes_zipcode").value.should eq "80210"

        find_field("user_billing_address_attributes_street").value.should eq "1234 big walk way"
        find_field("user_billing_address_attributes_city").value.should eq "Denver"
        find_field("user_billing_address_attributes_state").value.should eq "CO"
        find_field("user_billing_address_attributes_zipcode").value.should eq "80210"
      end
    end
  end
end
