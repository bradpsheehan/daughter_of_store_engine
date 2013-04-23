require 'spec_helper'

describe 'user account detail view' do
  context 'when the user is logged in' do
    before(:each) do
      @user = FactoryGirl.create(:user, email: 'raphael@example.com', password: 'password', password_confirmation: 'password')
      visit '/login'
      fill_in 'sessions_email', with: 'raphael@example.com'
      fill_in 'sessions_password', with: 'password'
      click_button 'Login'
      current_path.should == root_path
    end

    it 'display the main page of their account details' do
      current_path.should == root_path
      page.should have_link "Account"
      click_link 'Account'
      current_path.should == '/profile'
      expect(page).to have_content("Order History")
    end

    it 'cannot update their profile with incorrect information' do
      visit '/profile'
      fill_in 'user[full_name]', with: ''
      click_button 'Submit'
      expect(page).to have_content("can't be blank")
    end

    context 'when they click the link to their order history page' do
      it 'takes them to their order history page' do
        visit '/profile'
        click_link "Order History"
        expect(page).to have_content("Order History")
      end
    end

    context 'when they click on a specific order link' do
      it 'takes them to a view of their specific order' do
        order = FactoryGirl.create(:order, user: @user)
        visit 'account/orders'
        click_link "Order ##{order.id}"
        expect(page).to have_content("Quantity")
      end
    end
  end
end
