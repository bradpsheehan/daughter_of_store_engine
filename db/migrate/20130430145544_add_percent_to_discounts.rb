class AddPercentToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :percent, :boolean, :default => false
  end
end
