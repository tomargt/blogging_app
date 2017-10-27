class CommentsController < ApplicationController

  before_action :find_blog, only: [:create, :index]

  def index
    @comments = @blog.comments
  end

  def create
    @comment = @blog.comments.new(comment_params)
    if @comment.save
      flash[:success] = "Comment has been created successfully."
    else
      flash[:danger] = @comment.errors.full_messages.join("<br>")
    end
    redirect_to root_url
  end
 
  private

  def find_blog
    @blog = Blog.find(params[:blog_id]) rescue nil
    return redirect_to root_url, flash: { danger: "Blog does not exist" } if @blog.blank? 
    return redirect_to root_url, flash: { danger: "Blog not published" } unless @blog.published?
  end

  def comment_params
    params.require(:comment).permit(:commenter, :comment)
  end
end
