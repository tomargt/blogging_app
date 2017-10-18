class Blog < ApplicationRecord
  validates :title, presence: true, length: { minimum: 4 }
  validates :text, presence: true
  belongs_to :user
  has_many :comments, dependent: :destroy 

  scope :published_not_archived, -> { where(is_published: true, is_archived: false) }
  scope :not_archived, -> { where(is_archived: false) }
end
