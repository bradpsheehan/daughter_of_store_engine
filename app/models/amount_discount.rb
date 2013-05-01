class AmountDiscount
  def initialize(discount)
    @discount_id = discount.id
    @discount_amount = discount.amount
  end

  def message
    "Oh Yeah! You just got some dollars off!"
  end

  attr_reader :discount_id, :discount_amount

  def apply(cart)
    cart.pretotal - discount_amount
  end
end
