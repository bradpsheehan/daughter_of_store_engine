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

  def self.by_status(status)
    if status.present? && status != 'all'
      order.where(status: status)
    else
      scoped
    end
  end

  def self.create_pending_order(user, cart_items, session=nil)
    transaction do
      create(status: 'pending', user_id: user.id).tap do |order|
        cart_items.each do |cart_item|
          order.order_items.build(product_id: cart_item.product.id,
                                  unit_price: cart_item.unit_price,
                                  quantity: cart_item.quantity)
        end
        subtotal = Hash.new(0)
        order.order_items.each do |item|
          subtotal[:amount] += item.unit_price.truncate
        end
        if session[:discount]
          order.total = subtotal[:amount] - session[:discount]
          order.save
        else
          order.total = subtotal[:amount]
          order.save
        end
      end
    end
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
