class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  
  def index
  end

  def create
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.new(user: current_user)
    if favorite.save
      redirect_to request.referer, notice: 'いいねしました。'
    else
      redirect_to request.referer, alert: 'いいねに失敗しました。'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.find_by(user: current_user)
    if favorite.destroy
      redirect_to request.referer, notice: 'いいねを取り消しました。'
    else
      redirect_to request.referer, alert: 'いいねの取り消しに失敗しました。'
    end
  end
end
