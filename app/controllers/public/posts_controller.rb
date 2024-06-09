class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿に成功しました！"
      redirect_to posts_path
    else
      @user = current_user
      flash.now[:alert] = "投稿に失敗しました。"
      @posts = Post.page(params[:page])
      render :index
    end
  end

  def index
    @posts = Post.page(params[:page])
    @user = current_user
    @post = Post.new
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  private

  def post_params
    params.require(:post).permit(:title, :body, :post_image)
  end
  
  def is_matching_login_user
    post = Post.find(params[:id])
    unless post.user_id == current_user.id
      redirect_to posts_path
    end
  end
end