require 'spec_helper'

describe "admin dashboard" do
  before(:each) do
      admin = FactoryGirl.create(:user)
      @store = FactoryGirl.create(:store)
      Role.promote(admin, @store, 'admin')
      visit login_path
      fill_in 'sessions_email', with: 'brad@example.com'
      fill_in 'sessions_password', with: 'password'
      click_button 'Login'

      @user = FactoryGirl.create(:user, email: 'wtfz@whatthefuckzzzz.com')
      @order1 = FactoryGirl.create(:order, user: @user, status: 'paid', store: @store)
      @order2 = FactoryGirl.create(:order, user: @user, status: 'paid', store: @store)
      @order3 = FactoryGirl.create(:order, user: @user, status: 'returned', store: @store)
  end

  context "when an admin visits their dashboard" do
    before(:each) { visit store_admin_dashboard_path(@store) }
    it "should have a list of all orders and link to each" do
      expect(page).to have_xpath("//a[@href='#{store_admin_order_path(@store, @order1.id)}']")
      expect(page).to have_xpath("//a[@href='#{store_admin_order_path(@store, @order2.id)}']")
    end

    it "should show a total number of orders by status" do
      expect(page).to have_content('0 Pending')
      expect(page).to have_content('2 Paid')
      expect(page).to have_content('1 Returned')
      expect(page).to have_content('0 Shipped')
      expect(page).to have_content('0 Cancelled')
    end

    it "should allow for filtering by status" do
      click_link('Paid')
      expect(page).to have_css('tr', count: 2)
    end

    context "within an individual order" do
      before(:each) do
        @order = FactoryGirl.create(:order, user: @user, store: @store)
        @product = FactoryGirl.create(:product, store: @store)
        @order_item = FactoryGirl.create(:order_item, order: @order, product: @product)
        visit store_admin_order_path(@store, @order.id)
      end

      it "displays order creation date and time" do
        expect(page).to have_content(@order.created_at.to_s(:short))
        expect(page).to have_content(@order.updated_at.to_s(:short))
      end

      it "displays purchaser's full name and email address" do
        expect(page).to have_content(@user.email)
      end

      it "displays each product of the order with associated data" do
        expect(page).to have_content(@product.title)
        expect(page).to have_link(@product.title)
        expect(find("input#admin_order_item_quantity").value.to_i).to eq @order_item.quantity
        expect(page).to have_content(@order_item.unit_price)
        expect(page).to have_content(@order_item.subtotal)
      end

      it "displays order total" do
        expect(page).to have_content(@order.total)
      end

      it "displays order status" do
        expect(page).to have_content(@order.status)
      end

      context "can update the order by" do
        it "progressing status based on rules" do
          expect(page).to have_button('cancel')

          order = FactoryGirl.create(:order, user: @user, status: 'paid', store: @store)
          visit store_admin_order_path(@store, order.id)
          expect(page).to have_button('mark as shipped')

          order = FactoryGirl.create(:order, user: @user, status: 'shipped', store: @store)
          visit store_admin_order_path(@store, order.id)
          expect(page).to have_button('mark as returned')

          order = FactoryGirl.create(:order, user: @user, status: 'cancelled', store: @store)
          visit store_admin_order_path(@store, order.id)
          expect(page).to_not have_button('mark as returned')
          expect(page).to_not have_button('mark as shipped')
          expect(page).to_not have_button('cancel')
        end

        it "changing quantity ONLY when status pending or paid" do
          fill_in('admin_order_item_quantity', with: '10')
          click_button('Update')
          expect(page).to have_content(@order_item.unit_price * 10)

          expect(page).to have_xpath("//input[@id='admin_order_item_quantity']")
          click_button('cancel')
          expect(page).to_not have_xpath("//input[@id='admin_order_item_quantity']")
        end

        it "removing product ONLY when status pending or paid" do
          expect(page).to have_content(@product.title)
          click_button('Delete')
          expect(page).to_not have_content(@product.title)
        end
      end
    end
  end
end
