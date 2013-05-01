class Category < ActiveRecord::Migration
  def change
    add_column :categories, :promotion, :float, default: 0.0
  end
end
