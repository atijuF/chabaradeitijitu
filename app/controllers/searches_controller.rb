class SearchesController < ApplicationController
  def search
    @range = params[:range]
    @word = params[:word]
    @search = params[:search]
    if @range == "User"
      @users = User.looks(params[:search], params[:word]).page(params[:page])
    elsif @range == "Post"
      @posts = Post.looks(params[:search], params[:word]).page(params[:page])
    #elsif @range == "Tag"
    #  @posts = Post.joins(:tags).where(tags: { name: params[:word] }).distinct
    end
  end
end
