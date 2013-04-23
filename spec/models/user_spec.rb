require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:user)).to be_valid
  end

  it 'is invalid without an email' do
    expect(FactoryGirl.build(:user, email: nil)).to_not be_valid
  end

  it 'is invalid with a duplicate email' do
    FactoryGirl.create(:user)
    expect(FactoryGirl.build(:user)).to_not be_valid
  end

  it 'is invalid without a password' do
    expect(FactoryGirl.build(:user, password: '')).to_not be_valid
  end

  it 'is invalid without a full name' do
    expect(FactoryGirl.build(:user, full_name: '')).to_not be_valid
  end

  it 'is invalid if display name is not between 2-32 chars if it exists' do
    expect(FactoryGirl.build(:user, display_name: 'p')).to_not be_valid
    expect(FactoryGirl.build(:user, display_name: 'p' * 33)).to_not be_valid
    expect(FactoryGirl.build(:user, display_name: 'p' * 32)).to be_valid
  end

  it 'can self.new_guest(params=nil)' do
    guest = User.new_guest
    expect(guest[:full_name]).to eq 'Guest'
    expect(guest[:orphan]).to eq true
  end

  it 'can uber_up' do
    user = FactoryGirl.create(:user, uber: false)
    user.uber.should == false
    user.uber_up
    user.uber.should == true
  end

  it 'can uber?' do
    user = FactoryGirl.create(:user, uber: false)
    expect(user.uber?).to eq false
    user.uber_up
    expect(user.uber?).to eq true
  end

  it 'can orphan?' do
    user = FactoryGirl.create(:user, orphan: false)
    expect(user.orphan?).to eq false
    guest = User.new_guest
    expect(guest.orphan?).to eq true
  end
end
