# frozen_string_literal: true

##
# Model for tweets
class Tweet < ApplicationRecord
  validates :content, presence: true, allow_blank: false

  has_many :comments, dependent: :destroy
  has_many :attachments, dependent: :destroy
  belongs_to :user

  scope :restricted_for, (lambda { |user|
    where(private: false) unless user
  })

  scope :followed_by, (lambda { |user|
    where(user: user.following) if user
  })
end
