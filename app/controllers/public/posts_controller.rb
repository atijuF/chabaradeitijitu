class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]
  before_action :permit_sort_params, only: [:index]

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
    @user = current_user
    @new_post = Post.new
    @posts = sorted_posts.page(params[:page])
  end

  def show
    redirect_to posts_path and return if @post.status != 'active' && @post.user != current_user
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
  
  def sorted_posts
    case params[:sort]
    when 'newest'
      Post.active.order(created_at: :desc)
    when 'oldest'
      Post.active.order(created_at: :asc)
    when 'most_liked'
      Post.active.most_liked
    else
      Post.active.order(created_at: :desc)
    end
  end

  def permit_sort_params
    params.permit(:sort, :page)
  end
end