class Blog < ApplicationRecord
  validates :title, presence: true, length: { minimum: 3 }
  validates :text, presence: true

  belongs_to :user
  has_many :comments, dependent: :destroy 

  scope :published_blogs, -> { with_status(:published)}
  scope :archived_blogs, -> {with_status(:archived)}
  scope :draft_blogs, -> {with_status(:draft)}
  scope :user_blogs, -> {with_status(:published, :draft, :archived)} 

  before_save :published_post
  
  state_machine :status, initial: :draft do
    event :publish do
      transition draft: :published
    end
    event :archive do
      transition [:draft, :published]  => :archived
    end
  end
  
  def published_post
    if self.published? == true
      self.published_at = Time.now
    end
  end
end
