class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @posts = Post.page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "編集に成功しました！"
      redirect_to admin_post_path(@post)  
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id]) 
    post.destroy
    redirect_to admin_post_path
  end
  
   private

  def post_params
    params.require(:post).permit(:title, :body, :post_image, :status, :user_id, :tag_id)
    #, :tag_id) タグIDの許可
  end
end
