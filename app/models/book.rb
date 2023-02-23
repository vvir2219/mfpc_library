class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true

  has_many :borrows, dependent: :delete_all
end
