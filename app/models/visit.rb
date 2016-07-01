class Visit < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  validates :arrival, presence: true
  validate :only_one_active
  before_validation :set_arrival, if: -> { active_changed?(from: false, to: true) || (new_record? && active?) }
  before_validation :set_departure, if: -> { active_changed? from: true, to: false }

  scope :active, -> { where(active: true) }
  scope :approved, -> { joins(:user).where('users.approved' => true) }
  scope :approved_or_self, ->(user) { joins(:user).where('users.approved = ? or users.id = ?', true, user.id) }

  def depart!
    self.active = false
    save
  end

  def notify!
    name = user.try(:name) || 'someone'
    User.where(notify: true).each do |user|
      VisitMailer.notify(name, user.email).deliver
    end
  end

  private

  def only_one_active
    if active? && Visit.where(active: true, user_id: user_id).where('id is not ?', id).any?
      errors.add(:user_id, 'already has an active visit')
    end
  end

  def set_arrival
    self.arrival = Time.now
  end

  def set_departure
    self.departure = Time.now
  end
end
