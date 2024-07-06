class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: :create
  before_action :set_comment, only: :destroy

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    handle_comment_response(@comment.save, 'コメントが追加されました。', 'public/posts/show', 'error')
  end

  def destroy
    @comment.destroy
    handle_comment_response(true, 'コメントが削除されました。', post_path(@comment.post), nil)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def handle_comment_response(success, success_message, failure_html_view, failure_js_view)
    respond_to do |format|
      if success
        format.html { redirect_to post_path(@post), notice: success_message }
        format.js
      else
        format.html { render failure_html_view }
        format.js { render failure_js_view }
      end
    end
  end
end