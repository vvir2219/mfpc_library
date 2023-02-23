class Member < ApplicationRecord
  validates :name, presence: true

  has_many :borrows, dependent: :delete_all
end
