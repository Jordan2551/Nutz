class Article < ApplicationRecord
  has_many :likes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user
  validates_format_of :img_url, with: %r{\.(png|jpg|jpeg)\z}i, message: "Please provide a valid image."
  validates :description, length: {minimum: 1, maximum: 200}
end
