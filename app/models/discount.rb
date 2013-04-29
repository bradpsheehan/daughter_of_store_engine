class Discount < ActiveRecord::Base
  attr_accessible :amount, :name, :store_id

  validates_numericality_of :amount, {:greater_than => 0}
end
