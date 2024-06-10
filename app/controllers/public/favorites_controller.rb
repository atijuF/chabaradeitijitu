class Public::FavoritesController < ApplicationController
  def index
  end

  def create
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.new(user: current_user)
    if favorite.save
      redirect_to post_path(@post), notice: 'いいねしました。'
    else
      redirect_to post_path(@post), alert: 'いいねに失敗しました。'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.find_by(user: current_user)
    if favorite.destroy
      redirect_to post_path(@post), notice: 'いいねを取り消しました。'
    else
      redirect_to post_path(@post), alert: 'いいねの取り消しに失敗しました。'
    end
  end
end
