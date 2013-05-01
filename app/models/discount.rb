class Discount < ActiveRecord::Base
  attr_accessible :amount, :name, :store_id, :percent

  validates_numericality_of :amount, {:greater_than => 0}
  validates :name, presence: true

  def self.not_found
    MissingDiscount.new
  end

  attr_writer :message

  def self.find_by_name_and_store_id(discount_name,store_id)
    discount = where(name: discount_name, store_id: store_id).first
    convert_to_discount_object(discount)
  end

  def self.convert_to_discount_object(discount)
    if discount.nil?
      MissingDiscount.new
    elsif discount.percent
      PercentDiscount.new(discount)
    else
      AmountDiscount.new(discount)
    end
  end

end
