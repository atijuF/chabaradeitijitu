class Admin::TagsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_tag, only: [:edit, :update, :destroy]

  def index
    @tags = Tag.page(params[:page])
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to admin_tags_path, notice: 'タグが作成されました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to admin_tags_path, notice: 'タグが更新されました'
    else
      render :edit
    end
  end

  def destroy
    @tag.destroy
    redirect_to admin_tags_path, notice: 'タグが削除されました'
  end

  def search
    @tags = Tag.looks(params[:search], params[:word])
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_tags_path, alert: 'タグが見つかりません。'
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end