require 'spec_helper'

describe Discount do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:discount)).to be_valid
  end

  it 'is invalid without a title' do
    expect(FactoryGirl.build(:discount, name: '')).to_not be_valid
  end
end
