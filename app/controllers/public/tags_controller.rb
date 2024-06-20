class Public::TagsController < ApplicationController

  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts.page(params[:page])
  end
end
