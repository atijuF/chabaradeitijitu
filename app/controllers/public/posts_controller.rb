class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def new
    @new_post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    set_tag_list

    if @post.save
      flash[:notice] = "投稿に成功しました！"
      redirect_to @post
    else
      handle_create_error
    end
  end

  def index
    @posts = Post.where(status: 0).page(params[:page])
    @user = current_user
    @new_post = Post.new
  end

  def show
    redirect_to posts_path and return if @post.status != 'active'
    @user = @post.user
    @new_post = Post.new
  end

  def edit; end

  def update
    if @post.update(post_params)
      flash[:notice] = "編集に成功しました！"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to user_path(current_user)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :post_image, :favorite, :status, :tag_list)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def is_matching_login_user
    redirect_to posts_path unless @post.user_id == current_user.id
  end

  def set_tag_list
    if params[:post][:tag_list].present?
      tags = params[:post][:tag_list].split(',').map(&:strip).uniq
      @post.tag_list = tags.join(',')
    end
  end

  def handle_create_error
    @user = current_user
    @new_post = @post
    @posts = Post.page(params[:page])
    flash.now[:alert] = "投稿に失敗しました。"
    render :index
  end
end