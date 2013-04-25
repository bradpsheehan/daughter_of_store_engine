class AddPromotionColumnToProductTable < ActiveRecord::Migration
  def change
    add_column :products, :promotion, :float, default: 0
  end
end
