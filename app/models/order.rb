class Order < ApplicationRecord
  belongs_to :user, :optional => true

  validates :title, presence: true

  validates :description, presence: true

  validates :cost, presence: true,
                   numericality: { only_integer: true }
                    
  validates :time_to_complete, presence: true
end
