class Public::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:edit, :update, :destroy, :show]
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def edit
  end

  def show
    @posts = @user.posts.where(status: 0).page(params[:page])
    @new_post = Post.new
    @favorite_posts = user_signed_in? ? current_user.favorite_posts.page(params[:favorite_posts_page]).per(10) : @user.favorite_posts.page(params[:favorite_posts_page]).per(10)
    
    # ステータスが1の投稿の確認とメッセージ表示
    @inappropriate_post_message = "この投稿は不適切なため管理者によって削除されました。" if @user.posts.exists?(status: 1)
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "successfully"
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      sign_out @user  # ログアウト処理
      flash[:notice] = "退会しました"
      redirect_to root_path
    else
      flash[:alert] = "退会に失敗しました"
      redirect_to user_path(@user.id)
    end
  end
  
  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def is_matching_login_user
    redirect_to user_path(current_user.id) unless @user.id == current_user.id
  end
end