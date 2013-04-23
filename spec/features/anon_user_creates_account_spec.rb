require 'spec_helper'

describe 'new user creates and edits account' do
  def signup_user(email = "poetry@poetry.com")
    visit signup_path
    fill_in "Full Name", with: 'Maya Angelou'
    fill_in "Email", with: email
    fill_in "Display Name", with: 'poet'
    fill_in "user_password", with: 'poet'
    fill_in "user_password_confirmation", with: 'poet'
    click_button "Submit"
  end

  describe 'registering a new account' do
    before do
      Resque.stub(:enqueue).with(WelcomeEmailJob, "poetry@poetry.com", "Maya Angelou") { true }
    end

    context 'when they provide unique login info' do
      it 'creates a new user account' do
        signup_user
        expect(page).to have_content "Welcome, Maya Angelou"
        expect(current_path).to eq root_path
      end
    end

    context 'when they provide non-unique login info for registration' do
      it 'returns an error message' do
        email = "poetry@poetry.com"
        FactoryGirl.create(:user, email: email)

        visit signup_path
        fill_in "Full Name", with: 'NOT MAYA'
        fill_in "Email", with: email
        fill_in "Display Name", with: 'poet'
        fill_in "user_password", with: 'poet'
        fill_in "user_password_confirmation", with: 'poet'
        click_button "Submit"

        expect(page).to have_content "Emailhas already been taken"
        expect(current_path).to eq '/users'
      end
    end

  end

  describe 'signing in and out of account' do
    before(:each) do
      signup_user
    end

    it 'allows them to log out of their account' do
      visit login_path
      fill_in "Email", with: 'poetry@poetry.com'
      fill_in "Password", with: "poet"
      click_button "Login"
      expect(current_path).to eq root_path
      click_link_or_button "Logout"
      expect(current_path).to eq root_path
      expect(page).to have_content "Logged out!"
    end

    it 'rejects incorrect login info on signin' do
      visit login_path
      fill_in "Email", with: 'poetry@poetry.com'
      fill_in "Password", with: "whatsmypassword"
      click_button "Login"
      expect(current_path).to eq login_path
      expect(page).to have_content 'invalid'
    end
  end

  it 'edits the account with valid input' do
    user = FactoryGirl.create(:user, password: 'test123', password_confirmation: 'test123')

    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: 'test123'
    click_button "Login"

    visit profile_path
    fill_in "Display Name", with: 'Maya'
    click_button "Submit"
    expect(current_path).to eq profile_path
    expect(page).to have_content "updated account"
  end
end
