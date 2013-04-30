class Product < ActiveRecord::Base
  attr_accessible :title,
                  :description,
                  :price, :status,
                  :category_ids,
                  :store_id

  has_and_belongs_to_many :categories
  belongs_to :store

  validates :title, presence: :true,
                    uniqueness: { case_sensitive: false }
  validates :description, presence: :true
  validates :status, presence: :true,
                     inclusion: { in: %w(active retired) }
  validates :price, presence: :true,
                    format: { with: /^\d+??(?:\.\d{0,2})?$/ },
                    numericality: { greater_than: 0 }
  validates :store_id, presence: true

  validates :promotion, numericality: {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }

  scope :active, lambda { where(status: 'active') }

  # after_save :expire_cache

  # def self.expire_cache
  #   Rails.cache.expire('Product.all')
  # end

  def self.all_cached
    Rails.cache.fetch('Product.all',expires_in: 1.day) { all }
  end

  def self.by_category(category_id)
    if category_id.present?
      Category.find(category_id).products
    else
      scoped
    end
  end

  def promotion_savings
    (self.price * (self.promotion / 100)).to_i
  end

  def promo_price
    self.price - (self.price * (self.promotion/100))
  end

  def toggle_status
    if status == 'active'
      update_attributes(status: 'retired')
    elsif status == 'retired'
      update_attributes(status: 'active')
    end
  end
end
