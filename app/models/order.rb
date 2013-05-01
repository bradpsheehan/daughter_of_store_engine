class Order < ActiveRecord::Base
  attr_accessible :status, :user_id, :store_id, :total
  belongs_to :user
  belongs_to :store
  has_many :order_items, validate: true, dependent: :destroy
  has_many :products, through: :order_items
  has_one :billing_address, as: :addressable
  has_one :shipping_address, as: :addressable

  before_validation :generate_guid, on: :create

  validates :user_id, presence: true
  validates :guid, presence: true
  validates :status, presence: true,
                    inclusion: {in: %w(pending cancelled paid shipped returned),
                                  message: "%{value} is not a valid status" }

  def to_param
    guid
  end

  def savings
    original_value - promo_value
  end

  def original_value
    order_items.inject(0) do |memo, order_item|
      memo += order_item.product.price
      memo
    end
  end

  def promo_value
    unless find_product_promotion.class == BigDecimal
      find_product_promotion.inject(0) do |memo, price|
        memo += price
        memo
      end
    else
      find_product_promotion.truncate
    end
  end

  def find_product_promotion
    promos = order_items.inject([]) do |memo, order_item|
      memo << order_item.product.promo_price
      memo
    end
    originals = order_items.inject([]) do |memo, order_item|
      memo << order_item.product.price
      memo
    end
    if promos == originals
      return []
    else
      return promos
    end
  end

  def self.by_status(status)
    if status.present? && status != 'all'
      order.where(status: status)
    else
      scoped
    end
  end

  def self.create_pending_order(user, cart_items, discount)
    transaction do
      create(status: 'pending', user_id: user.id).tap do |order|

        # cart_items converting into an order

        cart_items.each do |cart_item|
          order.order_items.build(product_id: cart_item.product.id,
                                  unit_price: cart_item.unit_price,
                                  quantity: cart_item.quantity)
        end

        subtotal = Hash.new(0)
        order.order_items.each do |item|
          subtotal[:amount] += item.unit_price * item.quantity
        end

        # TODO: to make this work you need a new column
        # order.amount_of_savings = discount.discount_amount * 100

        # Set the total amount to the current subtotal
        order.total = subtotal[:amount]
        # Update the total amount with any discount amounts
        # Store the total amount in the database in pennies
        order.total = discount.apply(order) * 100
        order.save!

      end
    end
  end

  # HACK: This is so we can use cart calculator
  def pretotal
    total
  end

  # Convert database dollar value stored in pennies to dollars and cents
  def total_in_dollars_and_cents
    total.to_f / 100
  end

  def update_status
    next_status = { 'pending' => 'cancelled',
                    'paid' => 'shipped',
                    'shipped' => 'returned' }
    self.status = next_status[self.status]
    self.save
  end

#this is where we need to apply the discount
  # def total
  #   if order_items.present?
  #     order_items.map {|order_item| order_item.subtotal }.inject(&:+)
  #   elsif order_items.present? && session[:discount]
  #     order_items.map {|order_item| order_item.subtotal }.inject(&:+) - session[:discount ]
  #   end
  # end

  private

  def generate_guid
    self.guid = SecureRandom.uuid
  end
end
