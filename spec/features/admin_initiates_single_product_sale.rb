require 'spec_helper'

feature 'an admin can choose products to put on sale for their store' do
  context 'a registered admin exists' do
    context 'and they are logged in' do
      it 'do da ting' do
        visit '/'
        current_path.should == '/'
        page.should have_link "Login"
        click_link "Login"
        current_path.should == '/login'
        fill_in "sessions_email", :with => 'admin@admin.com'
        fill_in "sessions_password", :with => 'pass'
        current_path.should == '/login'
        page.should have_button "Login"
        click_button "Login"
        current_path.should == '/'
        visit '/pbj'
        current_path.should == '/pbj'
        page.should have_link "Admin"
        click_link "Admin"
        current_path.should == "/pbj/admin"
        page.should have_link == "Promotions"
        click_link "Promotions"
        current_path.should == "/pbj/admin/promotions"
      end
    end
  end
end
