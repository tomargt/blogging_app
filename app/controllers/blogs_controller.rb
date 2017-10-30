class BlogsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :current_blog, only: [ :edit, :update, :publish, :archive, :destroy]
  
  def index
    @blogs = Blog.published_blogs.order(published_at: :DESC).paginate(page: params[:page], per_page: 5)

  end
  
  def new
    @blog = current_user.blogs.new
  end

  def show
    if @blog = Blog.published_blogs.find(params[:id]) rescue nil
    else
      @blog = current_user.blogs.user_blogs.find(params[:id]) rescue nil
    end
    return redirect_to root_url, flash: { danger: "Invalid" } if @blog.blank?
  end

  def create
    @blog = current_user.blogs.new(blog_params)
    if @blog.save
      @blog.publish if params[:publish] == "Publish"
      flash[:success] = "Blog has been created sucessfully."
      redirect_to my_blogs_blogs_path
    else
      flash[:danger] = @blog.errors.full_messages.join("<br>")
      render 'new'
    end
  end

  def update
    if @blog.update(blog_params)
      flash[:success] = "Blog has been updated sucessfully."
      redirect_to my_blogs_blogs_path
    else
      flash[:danger] = @blog.errors.full_messages.join("<br>")
      render 'edit'
    end
  end

  def publish
    @blog.publish
    flash[:success] = "Blog has been sucessfully published."
    redirect_to my_blogs_blogs_path
  end

  def my_blogs
    @blogs = current_user.blogs.order(created_at: :desc).paginate(page: params[:page], per_page: 15)
  end

  def destroy
    @blog.destroy
    flash[:success] = "Blog has been deleted sucessfully."
    redirect_to my_blogs_blogs_path  
  end

  def archive
    @blog.archive
    flash[:success] = "Blog has been sucessfully archived."
    redirect_to my_blogs_blogs_path 
  end

  def archived_blogs
    @blogs = current_user.blogs.archived_blogs.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
  end

  private

  def blog_params
    params.require(:blog).permit(:title, :text, :id, :picture, :status, :published_at)
  end

  def current_blog
    @blog = current_user.blogs.find(params[:id]) rescue nil
    return redirect_to root_url, flash: { danger: "Invalid blog" } if @blog.blank?
  end 
end
