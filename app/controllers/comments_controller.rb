class CommentsController < ApplicationController

  def create
    @blog = Blog.find(params[:blog_id]) rescue nil
    @comment = @blog.comments.new(comment_params)
    if @comment.save
      flash[:success] = "Comment has been created successfully."
    else
      flash[:danger] = @comment.errors.full_messages.join("<br>")
    end
    redirect_to root_url
  end
 
  private

  def comment_params
    params.require(:comment).permit(:commenter, :comment)
  end
end
