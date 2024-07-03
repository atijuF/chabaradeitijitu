class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]
  
  def new
    @new_post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if params[:post][:tag_list].present?
      # タグリストの重複を取り除く
      tags = params[:post][:tag_list].split(',').map(&:strip).uniq
      @post.tag_list = tags.join(',')
    end
    if @post.save
      flash[:notice] = "投稿に成功しました！"
      redirect_to @post
    else
      @user = current_user
      @new_post = @post
      @posts = Post.page(params[:page])
      flash.now[:alert] = "投稿に失敗しました。"
      render :index
    end
  end

  def index
    @posts = Post.where(status: 0).page(params[:page])
    @user = current_user
    @new_post = Post.new
  end

  def show
    @post = Post.find(params[:id])
      redirect_to posts_path and return if @post.status != 'active'
    @user = @post.user
    @new_post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
    is_matching_login_user
  end
  
  def update
    is_matching_login_user
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "編集に成功しました！"
      redirect_to post_path(@post.id)  
    else
      render:edit
    end
  end
  
  def destroy
    post = Post.find(params[:id]) 
    post.destroy
    redirect_to user_path(current_user)
  end
  
  private

  def post_params
    params.require(:post).permit(:title, :body, :post_image, :favorite, :status, :tag_list)
  end
  
  def is_matching_login_user
    post = Post.find(params[:id])
    unless post.user_id == current_user.id
      redirect_to posts_path
    end
  end
end
