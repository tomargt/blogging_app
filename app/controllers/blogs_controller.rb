class BlogsController < ApplicationController

  before_action :authenticate_user!, except: [:index]
  before_action :current_blog, only: [:edit, :update, :publish, :archive, :destroy]
  
  def index
    @blogs = Blog.published_not_archived.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @blog = current_user.blogs.new
  end

  def edit
  end

  def create
    @blog = current_user.blogs.new(blog_params)
    if @blog.save
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
    notice = @blog.is_published ? "Blog was already published" : "Blog was sucessfully published"
    @blog.toggle!(:is_published) unless @blog.is_published
    redirect_to my_blogs_blogs_path, flash: { success: notice }
  end

  def my_blogs
    @blogs = current_user.blogs.not_archived.order(created_at: :desc).paginate(page: params[:page], per_page: 3)
  end

  def destroy
    if @blog.destroy
      flash[:success] = "Blog has been deleted sucessfully."
    else
      flash[:danger] = @blog.errors.full_messages.join("<br>")
    end
    redirect_to my_blogs_blogs_path  
  end

  def archive
    if @blog.toggle!(:is_archived)
      flash[:success] = "Blog has been sucessfully archived."
    else
      flash[:danger] = @blog.errors.full_messages.join("<br>")
    end  
    redirect_to my_blogs_blogs_path 
  end

  private
  
  def blog_params
    params.require(:blog).permit(:title, :text, :id, :picture)
  end

  def current_blog
    @blog = current_user.blogs.find(params[:id]) rescue nil
    redirect_to root_url, flash: { danger: "not authorized" } if @blog.blank?  
  end 
end
