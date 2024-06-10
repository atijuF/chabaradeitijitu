class Post < ApplicationRecord
  belongs_to :user
  belongs_to :tag, optional: true
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  has_one_attached :post_image
  
  def get_image
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      post_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpg')
    end
    post_image
  end
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
end
