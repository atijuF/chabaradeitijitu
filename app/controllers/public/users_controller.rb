class Public::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def edit
    @user = User.find(params[:id])
    is_matching_login_user
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.where(status: 0).page(params[:page])
    @new_post = Post.new
    @favorite_posts = @user.favorite_posts
    if user_signed_in?
      @favorite_posts = current_user.favorite_posts.page(params[:favorite_posts_page]).per(10)
    else
      @favorite_posts = @user.favorite_posts.page(params[:favorite_posts_page]).per(10)
    end
    # ステータスが1の投稿の確認とメッセージ表示
    @inappropriate_post_message = "この投稿は不適切なため管理者によって削除されました。" if @user.posts.exists?(status: 1)
  end

  def update
    is_matching_login_user
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "successfully"
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
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

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user.id)
    end
  end
end
