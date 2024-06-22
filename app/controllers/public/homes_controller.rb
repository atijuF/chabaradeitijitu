class Public::HomesController < ApplicationController
  def top
    @recent_posts = Post.recent_posts
    @popular_posts = Post.most_liked_posts
  end

  def about
  end
end
