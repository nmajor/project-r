class Book < ActiveRecord::Base
  attr_accessible :title, :subtitle, :blurb, :excerpt, :buy_link
  belongs_to :user
  acts_as_votable
  # has_many :comments
  # has_many :reviews
  # has_many :tags
  # has_many :genres
end
