require 'spec_helper'

describe Store do
  context 'users stores and usroles are creates' do
    let(:user){FactoryGirl.create(:user)}
    let(:user2){FactoryGirl.create(:user, uber: true, email: "fuck@weasle#{rand(1..100)}.com")}
    let(:user3){FactoryGirl.create(:user, email: "fuck@fuck#{rand(1..100)}.fuck")}
    let(:user4){FactoryGirl.create(:user, email: "fuck@fuck#{rand(1..100)}.fuck")}
    let!(:store){FactoryGirl.create(:store)}
    let!(:store2){FactoryGirl.create(:store, status: 'pending', name: 'pp', path: "ass")}
    let!(:user_role){FactoryGirl.create(:user_store_role, store_id: store.id, user_id: user3.id, role: 'admin')}
    let!(:user_role){FactoryGirl.create(:user_store_role, store_id: store.id, user_id: user4.id, role: 'stocker')}

    it "can do #is_admin?(user)" do
      expect(store.is_admin?(user)).to eq false
      expect(store.is_admin?(user2)).to eq true
    end

    it "can Store.themes" do
      expect(Store.themes).to include("soft")
    end

    it "can #is_stocker?" do
      expect(store.is_stocker?(user)).to eq false
      expect(store.is_stocker?(user4)).to eq true 
    end

    it 'can #to_param' do
      store.to_param.should eq 'a-store'
    end

    # it 'can #not_found' do
    #   store.not_found
    #   expect(raise ActionController::RoutingError.new('Not found'))
    # end

    it 'can #pending?' do
      expect(store.pending?).to eq false
      expect(store2.pending?).to eq true
    end

    it 'can #toggle_online_status' do
      expect(store.status).to eq 'online'
      store.toggle_online_status
      expect(store.status).to eq 'offline'
      store.toggle_online_status
      expect(store.status).to eq 'online'      
    end
  end
end
