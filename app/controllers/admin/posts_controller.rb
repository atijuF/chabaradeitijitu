class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.page(params[:page])
  end

  def show
    @user = @post.user
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "編集に成功しました！"
      redirect_to admin_post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: '投稿を削除しました。'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_posts_path, alert: '投稿が見つかりません。'
  end

  def post_params
    params.require(:post).permit(:title, :body, :post_image, :status, :user_id, :tag_id, :tag_list)
  end
end