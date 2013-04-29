class AddColumnStoreIdToDiscountTable < ActiveRecord::Migration
  def change
    add_column :discounts, :store_id, :integer
  end
end
