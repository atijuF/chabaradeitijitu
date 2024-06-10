class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :posts ,dependent: :destroy
  has_many :comments ,dependent: :destroy
  has_many :favorites ,dependent: :destroy
  has_many :relationships, dependent: :destroy
  has_many :follows ,dependent: :destroy
  has_many :followers ,dependent: :destroy
  #いいね一覧表示のため
  has_many :favorite_posts, through: :favorites, source: :post
  
  validates :name, presence: true
  
  has_one_attached :profile_image
  
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  def self.looks(search, word)
    if search == "forward_match"
      @users = User.where("name LIKE ?", "#{word}%")
    elsif search == "backward_match"
      @users = User.where("name LIKE ?", "%#{word}")
    elsif search == "perfect_match"
      @users = User.where(name: word)
    elsif search == "partial_match"
      @users = User.where("name LIKE ?", "%#{word}%")
    else
      @users = User.all
    end
  end
  
end
