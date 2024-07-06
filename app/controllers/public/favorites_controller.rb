class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    favorite = @post.favorites.new(user: current_user)
    handle_favorite_response(favorite.save, 'いいねしました。', 'いいねに失敗しました。')
  end

  def destroy
    favorite = @post.favorites.find_by(user: current_user)
    handle_favorite_response(favorite.destroy, 'いいねを取り消しました。', 'いいねの取り消しに失敗しました。')
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def handle_favorite_response(success, success_message, failure_message)
    respond_to do |format|
      if success
        format.html { redirect_to request.referer, notice: success_message }
        format.js   # 非同期通信に対応
      else
        format.html { redirect_to request.referer, alert: failure_message }
        format.js { render js: "alert('#{failure_message}');" }
      end
    end
  end
end