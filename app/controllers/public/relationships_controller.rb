class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  # フォローするとき
  def create
    @user = User.find(params[:user_id])
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end
  # フォロー外すとき
  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    redirect_to request.referer
  end
  # フォロー一覧
  def followings
    @user = User.find(params[:user_id])
    @users = @user.followings.page(params[:page]).per(10)
  end
  # フォロワー一覧
  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers.page(params[:page]).per(10)
  end
end
