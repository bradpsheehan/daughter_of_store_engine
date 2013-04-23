class Store < ActiveRecord::Base
  attr_accessible :description, :name, :path, :theme
  attr_accessible :status, as: :uber

  has_many :categories
  has_many :orders
  has_many :products
  has_many :user_store_roles

  before_validation :parameterize_path

  validates :name, presence: true,
                   uniqueness: true

  validates :path, presence: true,
                   uniqueness: true

  validates :status, presence: true,
                     inclusion: { in: %w(online offline pending declined) }

  validates :theme, presence: true,
                    inclusion: { in: %w(default wood soft mocha scale escheresque metal) }

  scope :approved, lambda { where("status <> 'declined'") }

  scope :online, lambda { where(status: 'online') }

  def is_admin?(user)
    user.uber? || UserStoreRole.exists?(store_id: self,
                                        user_id: user,
                                        role: 'admin')
  end

  def self.themes
    %w(default wood soft mocha scale escheresque metal)
  end

  def is_stocker?(user)
    UserStoreRole.exists?(store_id: self,
                          user_id: user,
                          role: :stocker)
  end

  def to_param
    path
  end

  def not_found
    raise ActionController::RoutingError.new('Not found')
  end

  def pending?
    self.status == 'pending'
  end

  def toggle_online_status
    if status == 'online'
      self.status = 'offline'
      self.save
    elsif status == 'offline'
      self.status = 'online'
      self.save
    end
  end

  private

  def parameterize_path
    self.path = path.parameterize
  end
end
