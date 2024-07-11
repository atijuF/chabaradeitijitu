class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :posts ,dependent: :destroy
  has_many :comments ,dependent: :destroy
  has_many :favorites ,dependent: :destroy
  #フォローしたされた
  has_many :relationships, foreign_key: :follower_id, dependent: :destroy
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: :follow_id, dependent: :destroy
  #一覧画面で使用
  has_many :followings, through: :relationships, source: :follow
  has_many :followers, through: :reverse_of_relationships, source: :follower
  #いいね一覧表示のため
  has_many :favorite_posts, through: :favorites, source: :post
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  
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
  # is_activeがtrueならfalseを返すようにしている
  def active_for_authentication?
    super && (is_active == true)
  end
  
  # フォローしたときの処理
  def follow(user_id)
    relationships.create(follow_id: user_id)
  end
  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(follow_id: user_id).destroy
  end
  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end
end

