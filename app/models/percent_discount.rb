class PercentDiscount
  def initialize(discount)
    @discount_id = discount.id
    @discount_amount = discount.amount.to_f / 100
  end

  def message
    "Percentage Discount Applied"
  end

  attr_reader :discount_id, :discount_amount

  def apply(cart)
    cart.pretotal.to_f * discount_amount
  end
end
