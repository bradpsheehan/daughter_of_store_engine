class Discount < ActiveRecord::Base
  attr_accessible :amount, :name, :store_id
end
