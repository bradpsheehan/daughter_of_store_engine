require 'spec_helper'

describe 'Role' do
  context 'self' do
    let(:user){FactoryGirl.create(:user)}
    let(:user2){FactoryGirl.create(:user, email: "fuck@weasle#{rand(1..100)}.com")}
    let(:user3){FactoryGirl.create(:user, email: "fuck@fuck#{rand(1..100)}.fuck")}
    let(:user4){FactoryGirl.create(:user, email: "fuck@fuck#{rand(1..100)}.fuck")}
    let!(:store){FactoryGirl.create(:store)}
    let!(:store2){FactoryGirl.create(:store, status: 'pending', name: 'pp', path: "ass")}
    let!(:user_role){FactoryGirl.create(:user_store_role, store_id: store.id, user_id: user3.id, role: 'admin')}
    let!(:user_role1){FactoryGirl.create(:user_store_role, store_id: store.id, user_id: user.id, role: 'stocker')}

    it 'can self.promote(user, store, role)' do
      user.user_store_roles.first.role == 'stocker'
      Role.promote(user,store,'admin')
      user.user_store_roles.first.role == 'admin'
      Role.promote(user2,store, 'admin')
      user2.user_store_roles.first.role != 'stocker'
    end

    it 'can self.revoke(user_id, store)' do
      user.user_store_roles.first.role == 'stocker'
      Role.revoke(user.id, store)
      user.user_store_roles == nil
    end
  end
end
