class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]
  
  def new
    @new_post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    #@post.tag_id = params[:post][:tag_id] タグIDの設定
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
    @posts = Post.page(params[:page])
    @user = current_user
    @new_post = Post.new
  end

  def show
    @post = Post.find(params[:id])
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
    params.require(:post).permit(:title, :body, :post_image, :favorite, :is_active)
    #, :tag_id) タグIDの許可
  end
  
  def is_matching_login_user
    post = Post.find(params[:id])
    unless post.user_id == current_user.id
      redirect_to posts_path
    end
  end
end