class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.new(user: current_user)
    if favorite.save
      respond_to do |format|
        format.html { redirect_to request.referer, notice: 'いいねしました。' }
        format.js   # 非同期通信に対応
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referer, alert: 'いいねに失敗しました。' }
        format.js { render js: "alert('いいねに失敗しました。');" }
      end
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.find_by(user: current_user)
    if favorite.destroy
      respond_to do |format|
        format.html { redirect_to request.referer, notice: 'いいねを取り消しました。' }
        format.js   # 非同期通信に対応
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referer, alert: 'いいねの取り消しに失敗しました。' }
        format.js { render js: "alert('いいねの取り消しに失敗しました。');" }
      end
    end
  end
end