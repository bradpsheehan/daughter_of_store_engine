class MissingDiscount
  def initialize
  end

  def message
    "Discount doesn't exist"
  end

  def discount_amount
    0
  end

  def apply(cart)
    cart.pretotal
  end
end

class PercentDiscount
  def initialize(amount)
    @discount_amount = amount.to_f / 100
  end

  def message
    "Percentage Discount Applied"
  end

  attr_reader :discount_amount

  def apply(cart)
    cart.pretotal.to_f * discount_amount
  end
end

class AmountDiscount
  def initialize(amount)
    @discount_amount = amount
  end

  def message
    "Oh Yeah! You just got some dollars off!"
  end

  attr_reader :discount_amount

  def apply(cart)
    cart.pretotal - discount_amount
  end
end

class Discount < ActiveRecord::Base
  attr_accessible :amount, :name, :store_id, :percent

  validates_numericality_of :amount, {:greater_than => 0}

  def self.not_found
    MissingDiscount.new
  end

  attr_writer :message

  def self.find_by_name_and_store_id(discount_name,store_id)
    discount = where(name: discount_name, store_id: store_id).first

    if discount.nil?
      MissingDiscount.new
    elsif discount.percent
      PercentDiscount.new(discount.amount)
    else
      AmountDiscount.new(discount.amount)
    end

  end

end
