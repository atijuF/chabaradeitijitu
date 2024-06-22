class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :posts, through: :post_tags

  validates :name, presence: true, uniqueness: true
  
  def self.looks(search, word)
    if search == "forward_match"
      @tags = Tag.where("name LIKE ?", "#{word}%")
    elsif search == "backward_match"
      @tags = Tag.where("name LIKE ?", "%#{word}")
    elsif search == "perfect_match"
      @tags = Tag.where(name: word)
    elsif search == "partial_match"
      @tags = Tag.where("name LIKE ?", "%#{word}%")
    else
      @tags = Tag.all
    end
  end
end
