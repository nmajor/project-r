class Book < ActiveRecord::Base
  attr_accessible :title, :subtitle, :blurb, :excerpt, :buy_link
  belongs_to :user
  acts_as_votable
  acts_as_commentable
  has_many :reviews, :as => :reviewable

  attr_accessor :book_score

  def book_score
    @book_score = (self.cached_votes_total * 0.5) + self.reviews.sum(:value) + (self.reviews.sum(:cached_votes_up) * 0.3)
  end

  # has_many :comments
  # has_many :reviews
  # has_many :tags
  # has_many :genres
end
