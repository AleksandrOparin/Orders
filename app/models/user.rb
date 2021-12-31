class User < ApplicationRecord
  attr_accessor :old_password

  has_many :orders
  
  has_secure_password validations: false

  # validate :correct_old_password, on: :update, if: -> { password.present? }

  validates :username, presence: true, 
                       uniqueness: true

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /\A[^@\s]+@[^@\s]+\z/ }

  validates :phone, presence: true,
                    uniqueness: true,
                    format: { with: /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/ }
                    
  validates :password, confirmation: { message: 'user.errors.password.confirmation' },
                       allow_blank: true,
                       length: { minimum: 6, maximum: 70, message: 'user.errors.password.length' }

  validate :password_presence
  validate :correct_old_password, on: :update, if: -> { password.present? }
  validate :password_complexity

  def correct_old_password
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)
                      
    errors.add :old_password
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])/

    errors.add :password, message: 'user.errors.password.complexity'
  end

  def password_presence
    errors.add(:password, :blank) unless password_digest.present?
  end
end
