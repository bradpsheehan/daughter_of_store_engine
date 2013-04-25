require 'spec_helper'

describe Mailer do
  it 'sends a welcome email' do
    user = FactoryGirl.create(:user, full_name: 'caka')
    email = Mailer.welcome_email(user, user.full_name).deliver
    expect(ActionMailer::Base.deliveries).to_not be_empty
  end

  it 'sends an order confirmation email' do
    user = FactoryGirl.create(:user, full_name: 'dookie')
    order = FactoryGirl.create(:order, user: user)
    order.stub(:total).and_return(9)
    email = Mailer.order_confirmation(user, order.id, order.total).deliver
    expect(ActionMailer::Base.deliveries).to_not be_empty
  end
end
