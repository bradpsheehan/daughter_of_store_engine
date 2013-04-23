require 'spec_helper'

feature "Public User Views Products" do

  context "the root page" do
    before(:each) do
      @store = FactoryGirl.create(:store)
      @product = FactoryGirl.create(:product, store: @store)
      visit store_home_path(@store)
    end

    it "displays products" do
      page.should have_content(@product.title)
    end
  end

  context "the product page" do
    before(:each) do
      @store = FactoryGirl.create(:store)
      @product = FactoryGirl.create(:product, store: @store)
      visit store_product_path(@store, @product)
    end

    it "displays the product name" do
      page.should have_content @product.title
    end

    it "has an add-to-cart action" do
      visit store_product_path(@store, @product)
      expect(page).to have_button("Add to Cart")
    end
  end
end
