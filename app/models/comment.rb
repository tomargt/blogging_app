class Comment < ApplicationRecord
  belongs_to :blog
  validates :commenter, presence: true
  validates :comment, presence: true
end
