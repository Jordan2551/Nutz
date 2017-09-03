class Like < ApplicationRecord
  belongs_to :article
  belongs_to :user

  #TODO: ADD UNIQUENESS TO BOTH
  # validates :user_id [:article_id, :user_id] message: 'You have already liked this post.'}
  # validates :article_id, uniqueness: {message: 'You have already liked this post.'}

end
