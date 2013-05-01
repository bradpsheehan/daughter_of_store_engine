class MissingDiscount
  def initialize
  end

  def message
    "Discount doesn't exist"
  end

  def discount_amount
    0
  end

  def discount_id
    nil
  end

  def apply(cart)
    cart.pretotal
  end
end
