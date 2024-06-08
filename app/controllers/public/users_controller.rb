class Public::UsersController < ApplicationController
  def mypage
  end

  def edit
    @user = User.find(params[:id])
    is_matching_login_user
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page])
    #@book = Book.new
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
