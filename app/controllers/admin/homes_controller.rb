class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!
  def top
    @recent_posts = Post.recent_posts
    @popular_posts = Post.most_liked_posts
  end
end
