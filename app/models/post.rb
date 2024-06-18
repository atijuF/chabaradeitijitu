class Post < ApplicationRecord
  belongs_to :user
  belongs_to :tag, optional: true
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  has_one_attached :post_image
  enum status: {active: 0, inactive: 1}
  
  validates :title, presence: true
  validates :body, presence: true
  
  def get_image
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      post_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpg')
    end
    post_image
  end
  
  def favorited_by?(user)
    return false unless user
    favorites.exists?(user_id: user.id)
  end
  
  #検索機能、SQLのOR条件使用
  def self.looks(search, word)
    if search == "forward_match"
      @posts = Post.where("title LIKE ? OR body LIKE ?", "#{word}%", "#{word}%")
    elsif search == "backward_match"
      @posts = Post.where("title LIKE ? OR body LIKE ?", "%#{word}", "%#{word}")
    elsif search == "perfect_match"
      @posts = Post.where("title = ? OR body = ?", word, word)
    elsif search == "partial_match"
      @posts = Post.where("title LIKE ? OR body LIKE ?", "%#{word}%", "%#{word}%")
    else
      @posts = Post.all
    end
  end
  
  def self.active_posts_count
    where(status: :active).count
  end
end
