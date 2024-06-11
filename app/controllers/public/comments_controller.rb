class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params) #build 関連オブジェクトを自動的に作成し、関連性を構築するための外部キーを設定する
    @comment.user = current_user
    if @comment.save
      redirect_to post_path(@post), notice: 'コメントが追加されました。'
    else
      render 'public/posts/show'
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to post_path(@comment.post), notice: 'コメントが削除されました。'
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:comment)
  end
end